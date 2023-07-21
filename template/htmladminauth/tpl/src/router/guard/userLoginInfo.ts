import type { Router, LocationQueryRaw } from 'vue-router';
import NProgress from 'nprogress'; // progress bar

import { useMyStore } from '@/store';
export default function setupUserLoginInfoGuard(router: Router) {
  router.beforeEach(async (to, from, next) => {
    NProgress.start();
    const userStore = useMyStore();
    if (to.name === 'login') {
      next();
      return;
    } else if (userStore.getToken !== '') {
      if (!userStore.userInfo.account) {
        try {
          await userStore.getInfo();
          await userStore.apiGetAuth();
          next();
        } catch (error) {
          next({
            name: 'login',
            query: {
              redirect: to.name,
              ...to.query,
            } as LocationQueryRaw,
          });
        }
      } else {
        try {
          await userStore.checkToken();
        } catch (err) {
          console.error('err check token', err);
        }
        next();
      }
    } else {
      next({
        name: 'login',
        query: {
          redirect: to.name,
          ...to.query,
        } as LocationQueryRaw,
      });
    }
  });
}
