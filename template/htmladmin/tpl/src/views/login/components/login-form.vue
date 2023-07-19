<template>
  <div class="login-form-wrapper">
    <div class="login-form-title">登陆</div>
    <div class="login-form-sub-title">欢迎使用</div>
    <!-- <div class="login-form-error-msg">{{ errorMessage }}</div> -->
    <a-form ref="loginForm" :model="userInfo" class="login-form" layout="vertical" @submit="handleSubmit">
      <a-form-item field="account" :rules="[{ required: true, message: '账号不能为空' }]" :validate-trigger="['change', 'blur']"
        hide-label>
        <a-input v-model="userInfo.account" placeholder='账号'>
          <template #prefix>
            <icon-user />
          </template>
        </a-input>
      </a-form-item>
      <a-form-item field="password" :rules="[{ required: true, message: '密码不能为空' }]"
        :validate-trigger="['change', 'blur']" hide-label>
        <a-input-password v-model="userInfo.password" placeholder='密码' allow-clear>
          <template #prefix>
            <icon-lock />
          </template>
        </a-input-password>
      </a-form-item>
      <a-space :size="16" direction="vertical">
        <div class="login-form-password-actions">
          <a-checkbox checked="rememberPassword" :model-value="loginConfig.rememberPassword"
            @change="setRememberPassword as any">
            记住密码
          </a-checkbox>
        </div>
        <a-button type="primary" html-type="submit" long :loading="loading">
          登陆
        </a-button>
      </a-space>
    </a-form>
  </div>
</template>

<script lang="ts" setup>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { Message, Notification } from '@arco-design/web-vue';
import { ValidatedError } from '@arco-design/web-vue/es/form/interface';
import { useI18n } from 'vue-i18n';
import { useStorage } from '@vueuse/core';
import { useMyStore } from '@/store';
import useLoading from '@/hooks/loading';
import type { LoginData } from '@/api/my';

const router = useRouter();
const { t } = useI18n();
const errorMessage = ref('');
const { loading, setLoading } = useLoading();
const userStore = useMyStore();

const loginConfig = useStorage('login-config', {
  rememberPassword: true,
  account: '', // 演示默认值
  password: '', // demo default value
});
const userInfo = reactive({
  account: loginConfig.value.account,
  password: loginConfig.value.password,
});

const handleSubmit = async ({
  errors,
  values,
}: {
  errors: Record<string, ValidatedError> | undefined;
  values: Record<string, any>;
}) => {
  if (loading.value) return;
  if (!errors) {
    setLoading(true);
    try {
      await userStore.login(values as LoginData);
      const { redirect, ...othersQuery } = router.currentRoute.value.query;
      router.push({
        name: (redirect as string) || 'Workplace',
        query: {
          ...othersQuery,
        },
      });
      Notification.success({ title: '登陆成功', content: "" });
      const { rememberPassword } = loginConfig.value;
      const { account, password } = values;
      // 实际生产环境需要进行加密存储。
      // The actual production environment requires encrypted storage.
      loginConfig.value.account = rememberPassword ? account : '';
      loginConfig.value.password = rememberPassword ? password : '';
    } catch (err) {
      errorMessage.value = (err as Error).message;
    } finally {
      setLoading(false);
    }
  }
};
const setRememberPassword = (value: boolean) => {
  loginConfig.value.rememberPassword = value;
};
</script>

<style lang="less" scoped>
.login-form {
  &-wrapper {
    width: 320px;
  }

  &-title {
    color: var(--color-text-1);
    font-weight: 500;
    font-size: 24px;
    line-height: 32px;
  }

  &-sub-title {
    color: var(--color-text-3);
    font-size: 16px;
    line-height: 24px;
  }

  &-error-msg {
    height: 32px;
    color: rgb(var(--red-6));
    line-height: 32px;
  }

  &-password-actions {
    display: flex;
    justify-content: space-between;
  }

  &-register-btn {
    color: var(--color-text-3) !important;
  }
}
</style>
