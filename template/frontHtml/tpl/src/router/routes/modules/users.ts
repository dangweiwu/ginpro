import { DEFAULT_LAYOUT } from '../base';
import { AppRouteRecordRaw } from '../types';

const USER: AppRouteRecordRaw = {
  path: '/users',
  name: 'users',
  component: DEFAULT_LAYOUT,
  meta: {
    locale: '用户管理',
    icon: 'icon-user',
    requiresAuth: false,
    order: 3,
  },
  children: [
    {
      path: 'setting',
      name: 'Setting',
      component: () => import('@/views/users/index.vue'),
      meta: {
        locale: '用户',
        requiresAuth: false,
        roles: ['*'],
      },
    },
  ],
};

export default USER;
