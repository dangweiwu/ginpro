import axios from 'axios';
import type { AxiosRequestConfig, AxiosResponse } from 'axios';
import { Message, Modal,Notification } from '@arco-design/web-vue';
import { useMyStore } from '@/store';

export interface HttpResponse<T = unknown> {
  status: number;
  msg: string;
  code: number;
  data: T;
}

if (import.meta.env.VITE_API_BASE_URL) {
  axios.defaults.baseURL = import.meta.env.VITE_API_BASE_URL;
}

axios.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    const tokenStore = useMyStore();
    if (tokenStore.getToken) {
      if (!config.headers) {
        config.headers = {};
      }
      config.headers.Authorization = `Bearer ${tokenStore.access_token}`;
    }
    return config;
  },
  (error) => {
    // do something
    return Promise.reject(error);
  }
);
// add response interceptors
axios.interceptors.response.use(
  (response: AxiosResponse<HttpResponse>) => {
    const res = response.data;
    return res;
  },
  (error) => {
    // if status 404 must error
    // if network error must error no response
    // if status 400 must error

    let errMsg = '';
    let context = '';
    if (error.response === undefined) {
      // 网络不通
      errMsg = error.message || 'Request Error';
    } else if (error.response.status === 400) {
      // 错误处理
      errMsg = error.response.data.msg;
    } else if (error.response.status === 404) {
      // not found
      errMsg = 'ERR 404';
    } else if (error.response.status === 500) {
      // 系统错误
      errMsg = error.response.data;
    } else if (error.response.status === 401) {
      // 重新登陆
      Modal.error({
        title: '您已退出登录',
        okText: '确定',
        async onOk() {
          const userStore = useMyStore();
          await userStore.logoutCallBack();
          window.location.reload();
        },
        content: '',
      });
      return Promise.reject(error);
    } else if (error.response.status === 403) {
      // 无权限
      errMsg = '缺少权限';
      context = error.response.data.data;
    }

    Notification.warning({
      title: errMsg,
      content: context,
    })
    return Promise.reject(error);
  }
);
