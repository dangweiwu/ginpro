import axios from 'axios';

//query 分页数据
export function apiAuths(params) {
    return axios.get('/api/auth', { params });
}

//创建
export function apiCreateAuths(data) {
    return axios.post('/api/auth', data);
}

//更新
export function apiUpdateAuths(id, data) {
    return axios.put('/api/auth/' + id, data);
}

//删除
export function apiDelAuths(id) {
    return axios.delete('/api/auth/' + id);
}

//apilist
export function apiApiList(){
    return axios.get("/api/allurl")
}
