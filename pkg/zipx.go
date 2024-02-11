package pkg

import (
	"archive/zip"
	"bytes"
	"embed"
	"io"
	"os"
	"path"
	"path/filepath"
)

func UnZipEmbedFile(storename string, root string, fs2 embed.FS, handler func(filename string, cont []byte) ([]byte, error)) error {

	embedfile, err := fs2.Open(storename)
	defer embedfile.Close()
	if err != nil {
		return err
	}

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
