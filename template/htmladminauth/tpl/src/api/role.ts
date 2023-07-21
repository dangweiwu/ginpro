import axios from 'axios';

//query 分页数据
export function apiRole(params) {
    return axios.get('/api/role', { params });
}

//创建
export function apiCreateRole(data) {
    return axios.post('/api/role', data);
}

//更新
export function apiUpdateRole(id, data) {
    return axios.put('/api/role/' + id, data);
}

//删除
export function apiDelRole(id) {
    return axios.delete('/api/role/' + id);
}

export function apiRoleAuth(id,data) {
    return axios.put('/api/role/auth/' + id,data);
}

