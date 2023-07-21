import axios from 'axios';

export interface LoginData {
  account: string;
  password: string;
}

export interface RefreshToken {
  refresh_token: string;
}

export function login(data: LoginData) {
  return axios.post('/api/login', data);
}

export function logout() {
  return axios.post('/api/logout');
}

export function myInfo() {
  return axios.get('/api/my');
}

//token 刷新
export function refreshtoken(t: RefreshToken) {
  return axios.post('/api/token/refresh', t);
}

//设置
export function setinfo(data) {
  return axios.put('/api/my', data);
}

//设置密码
export function setPassword(data) {
  return axios.put('/api/my/password', data);
}


//获取我的权限
export function apiMyAuth(){
  return axios.get('/api/my-auth')
}