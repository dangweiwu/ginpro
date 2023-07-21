import { defineStore } from 'pinia';
import {
  login as myLogin,
  logout as myLogout,
  myInfo,
  LoginData,
  apiMyAuth,
} from '@/api/my';

import { removeRouteListener } from '@/utils/route-listener';
import { UserState } from './types';
import useAppStore from '../app';

import { refreshtoken } from '@/api/my';

const useMyStore = defineStore('my', {
  state: (): UserState => ({
    account: '',
    phone: '',
    name: '',
    email: '',
    is_super_admin: '',
    role: '',
    memo: '',
    access_token: '',
    refresh_at: 0,
    refresh_token: '',
    auths:[],
  }),

  getters: {
    userInfo(state: UserState) {
      return {
        account: state.account,
        phone: state.phone,
        name: state.name,
        email: state.email,
        is_super_admin: state.is_super_admin,
        role:state.role,
        auths:state.auths
      };
    },
    isTimeout: (state): boolean => {
      if (!state.refresh_at) {
        let at = getRefreshAt();
        state.refresh_at = at;
      }
      return new Date().valueOf() / 1000 > state.refresh_at;
    },
    getToken: (state): string => {
      if (!state.access_token) {
        state.access_token = getToken();
      }
      return state.access_token;
    },
    getRefreshToken: (state): string => {
      if (!state.refresh_token) {
        state.refresh_token = getRefreshToken();
      }
      return state.refresh_token;
    },
  },

  actions: {
    resetInfo() {
      this.$reset();
    },
    setInfo(data) {
      this.name = data.name;
      this.phone = data.phone;
      this.memo = data.memo;
      this.email = data.email;
    },
    async checkToken() {
      if (this.isTimeout) {
        const res = await refreshtoken({ refresh_token: this.getRefreshToken });
        setRefreshAt(res.refresh_at);
        setRefreshToken(res.refresh_token);
        setToken(res.token);
        this.access_token = res.token;
        this.refresh_at = res.refresh_at;
        this.refresh_token = res.token;
      }
    },
    setToken(token: string, refresToken: string, refreshAt: number) {
      setRefreshAt(refreshAt);
      setRefreshToken(refresToken);
      setToken(token);
      this.access_token = token;
      this.refresh_at = refreshAt;
      this.refresh_token = refresToken;
    },
    //清空所有
    clearToken() {
      this.access_token = '';
      this.refresh_at = 0;
      this.refresh_token = '';
      localStorage.removeItem('token');
      localStorage.removeItem('refreshtoken');
      localStorage.removeItem('refreshAt');
    },

    // Get user's information
    async getInfo() {
      const res = await myInfo();

      console.log('info:', res);
      this.account = res.account;
      this.phone = res.phone;
      this.name = res.name;
      this.email = res.email;
      this.memo = res.memo;
      this.is_super_admin = res.is_super_admin;
      this.role = res.role;
    },

    async apiGetAuth(){
      try{
        // if()
        console.log("this.is_super_admin",this.is_super_admin)
        if(this.is_super_admin != "1"){
          const res = await apiMyAuth();
          this.auths = res.data
        }

      }catch(err){
        console.log(err)
      }
    },

    // Login
    async login(loginForm: LoginData) {
      try {
        console.log('logint==');
        const res = await myLogin(loginForm);

        this.setToken(res.access_token, res.refresh_token, res.refresh_at);
        console.log('logresponse:', res);
      } catch (err) {
        console.log('login error:', err, (err as Error).message);
        throw err as Error;
      }
    },
    logoutCallBack() {
      const appStore = useAppStore();
      this.resetInfo();

      removeRouteListener();
      appStore.clearServerMenu();
      this.clearToken();
    },
    // Logout
    async logout() {
      try {
        await myLogout();
      } finally {
        this.logoutCallBack();
      }
    },
  },
});

export default useMyStore;

function setToken(token: string) {
  localStorage.setItem('token', token);
}

function getToken() {
  let t = localStorage.getItem('token');
  if (!t) {
    return '';
  } else {
    return t;
  }
}

function setRefreshToken(refreshtoken: string) {
  localStorage.setItem('refreshtoken', refreshtoken);
}

function getRefreshToken() {
  let t = localStorage.getItem('refreshtoken');
  if (!t) {
    return '';
  } else {
    return t;
  }
}

function setRefreshAt(at: number) {
  localStorage.setItem('refreshAt', String(at));
}

function getRefreshAt() {
  let t = localStorage.getItem('refreshAt');
  if (!t) {
    return 0;
  } else {
    return parseInt(t);
  }
}

// function setAuth(data){
//   localStorage.setItem("auth",data)
// }

// function getAuth(){
//   let t = localStorage.getItem('auth');
//   if (!t) {
//     return [];
//   } else {
//     return JSON.parse(t);
//   }
// }