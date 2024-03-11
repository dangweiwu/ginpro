package pkg

import (
	"archive/zip"
	"bytes"
	"embed"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"strings"
	"time"
)

func ZipFile(root, zipname string, ignore []string) error {
	zipFile, err := os.Create(zipname)
	if err != nil {
		return err
	}
	defer zipFile.Close()
	archive := zip.NewWriter(zipFile)
	defer archive.Close()

	filepath.Walk(root, func(pt string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		fmt.Println("[info]", pt, info.Name())
		for _, v := range ignore {

			n := strings.Index(pt, v)
			if v == info.Name() || n >= 0 {
				return nil
			}
		}
		header, err := zip.FileInfoHeader(info)
		if err != nil {
			return err
		}
		header.Name = pt
		if info.IsDir() {
			header.Name += "/"
		} else {
			header.Method = zip.Deflate
		}
		writer, err := archive.CreateHeader(header)
		if err != nil {
			return err
		}
		if !info.IsDir() {
			file, err := os.Open(pt)
			if err != nil {
				return err
			}
			defer file.Close()
			_, err = io.Copy(writer, file)
			if err != nil {
				return err
			}
		}
		return nil
	})
	return nil
}

func UnZipEmbedFile(storename string, root string, fs2 embed.FS, handler func(filename string, cont []byte) ([]byte, error)) error {

	embedfile, err := fs2.Open(storename)
	time.Sleep(time.Second)
	if err != nil {
		return err
	}
	defer embedfile.Close()

	tmpFilePath := path.Join(root, storename)
	defer func() {
		os.RemoveAll(tmpFilePath)
	}()

	os.MkdirAll(root, 0x777)

	tmpFile, err := os.OpenFile(tmpFilePath, os.O_CREATE|os.O_TRUNC|os.O_RDWR, 0x777)
	defer tmpFile.Close()
	if err != nil {
		return err
	}
	_, err = io.Copy(tmpFile, embedfile)
	if err != nil {
		return err
	}

	reader, err := zip.OpenReader(tmpFilePath)
	if err != nil {
		return err
	}

	defer reader.Close()

	for _, file := range reader.File {
		destPath := filepath.Join(root, file.Name)
		if file.FileInfo().IsDir() {
			os.MkdirAll(destPath, file.Mode())
			continue
		}

		sourceFile, err := file.Open()
		if err != nil {
			return err
		}
		defer sourceFile.Close()

		buf := bytes.NewBuffer([]byte{})

		_, err = buf.ReadFrom(sourceFile)
		if err != nil {
			return err
		}

		bts, err := handler(file.Name, buf.Bytes())
		if err != nil {
			return err
		}

		destFile, err := os.Create(destPath)
		defer destFile.Close()
		if err != nil {
			return err
		}

		if _, err := destFile.Write(bts); err != nil {
			return err
		}
	}
	return nil
}
