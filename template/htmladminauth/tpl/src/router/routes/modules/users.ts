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
      path: '/setting',
      name: 'Setting',
      component: () => import('@/views/users/index.vue'),
      meta: {
        locale: '用户管理',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    {
      path: '/auths',
      name: 'auths',
      component: () => import('@/views/auths/index.vue'),
      meta: {
        locale: '权限管理',
        requiresAuth: true,
        roles: ['auth'],
      },
    },
    {
      path: '/role',
      name: 'role',
      component: () => import('@/views/role/index.vue'),
      meta: {
        locale: '角色管理',
        requiresAuth: true,
        roles: ['role'],
      },
    },
  ],
};

export default USER;
