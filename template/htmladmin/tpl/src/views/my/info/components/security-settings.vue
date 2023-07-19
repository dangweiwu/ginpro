<template>
  <div class="box">
    <a-form ref="formRef" :model="formData" class="form" :label-col-props="{ span: 8 }" :wrapper-col-props="{ span: 16 }">
      <a-form-item field="password" label="原始密码" :rules="[
        {
          required: true,
          message: '缺少原始密码',
        },
      ]">
        <a-input v-model="formData.password" placeholder="原始密码"> </a-input>
      </a-form-item>
      <a-form-item field="new_password" label="新密码" :rules="[
        {
          required: true,
          message: '缺少新密码',
        },
        {
          message: '不能少于6个字符',
          minLength: 6,
        },
      ]">
        <a-input v-model="formData.new_password" placeholder="新密码">
        </a-input>
      </a-form-item>

      <a-form-item field="new_password2" label="重复密码" :rules="[
        {
          required: true,
          message: '缺少重复密码',
        },
        {
          validator: checkPassword,
        },
      ]">
        <a-input v-model="formData.new_password2" placeholder="重复密码"> </a-input>
      </a-form-item>
      <a-form-item>
        <a-space>
          <a-button type="primary" @click="validate">
            保存
          </a-button>
          <a-button type="secondary" @click="reset">
            重置
          </a-button>
        </a-space>
      </a-form-item>
    </a-form>
  </div>
</template>

<script setup>
//设定
import { ref, reactive, onMounted } from 'vue';
import { Message, Modal, Notification } from '@arco-design/web-vue';
import { useAppStore, useMyStore } from '@/store';
import { setinfo, myInfo, setPassword } from '@/api/my';
import { removeRouteListener } from '@/utils/route-listener';
import router from '@/router'
import { DEFAULT_ROUTE_NAME } from '@/router/constants'

import { useStorage } from '@vueuse/core';

const formRef = ref();
const mystore = useMyStore()

const formData = reactive({
  password: "",
  new_password: "",
  new_password2: "",
})

const checkPassword = (value, cb) => {
  if (value != formData.new_password) {
    cb("重复密码不一致");
  }
};


const validate = async () => {
  const res = await formRef.value?.validate();
  if (res) {
    return;
  }
  //数据发送

  try {
    await setPassword({
      password: formData.password,
      new_password: formData.new_password,
    });
    Notification.success({ title: "修改成功! 正在重新登录。" });
    setTimeout(() => {
      const appStore = useAppStore();
      mystore.clearToken();

      // removeRouteListener();
      // appStore.clearServerMenu();
      var val = localStorage.getItem("login-config");//获取存储的元素
      var dataobj = JSON.parse(val);//解析出json对象
      dataobj.password = "";
      localStorage.setItem("login-config", JSON.stringify(dataobj));
      router.push({ name: 'login' })

    }, 1500)

  } catch (err) { }
};

const reset = async () => {
  await formRef.value?.resetFields();
};
</script>

<style scoped lang="less">
.box {
  padding-top: 30px;
}

.form {
  width: 540px;
  margin: 0 auto;
}
</style>
