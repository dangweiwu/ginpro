import { useRouter } from 'vue-router';
import { Message,Notification } from '@arco-design/web-vue';

import { useMyStore } from '@/store';

export default function useUser() {
  const router = useRouter();
  const userStore = useMyStore();
  const logout = async (logoutTo?: string) => {
    await userStore.logout();
    const currentRoute = router.currentRoute.value;
    Notification.success({title:'登出成功',content:""});
    router.push({
      name: logoutTo && typeof logoutTo === 'string' ? logoutTo : 'login',
      query: {
        ...router.currentRoute.value.query,
        redirect: currentRoute.name as string,
      },
    });
  };
  return {
    logout,
  };
}
