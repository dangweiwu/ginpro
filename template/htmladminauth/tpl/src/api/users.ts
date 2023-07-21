import axios from 'axios';

export function apiUsers(params) {
  return axios.get('/api/admin', { params });
}
export function apiCreateUser(data) {
  return axios.post('/api/admin', data);
}

export function apiUpdateUser(id, data) {
  return axios.put('/api/admin/' + id, data);
}

export function apiDelUser(id) {
  return axios.delete('/api/admin/' + id);
}
