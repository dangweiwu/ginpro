import axios from 'axios';

//query 分页数据
export function api[[UpFirst .Name]](params) {
    return axios.get('/api/[[.Name]]', { params });
}

//创建
export function apiCreate[[UpFirst .Name]](data) {
    return axios.post('/api/[[.Name]]', data);
}

//更新
export function apiUpdate[[UpFirst .Name]](id, data) {
    return axios.put('/api/[[.Name]]/' + id, data);
}

//删除
export function apiDel[[UpFirst .Name]](id) {
    return axios.delete('/api/[[.Name]]/' + id);
}
