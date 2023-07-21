import { DEFAULT_LAYOUT } from '../base';
import { AppRouteRecordRaw } from '../types';

const USER: AppRouteRecordRaw = {
  path: '/my',
  name: 'my',
  component: DEFAULT_LAYOUT,
  meta: {
    locale: '个人中心',
    icon: 'icon-user',
    requiresAuth: false,
    order: 1,
  },
  children: [
    {
      path: '/mysetting',
      name: 'mysetting',
      component: () => import('@/views/my/info/index.vue'),
      meta: {
        locale: '我的设置',
        requiresAuth: false,
        roles: ['*'],
      },
    },
  ],
};

export default USER;
