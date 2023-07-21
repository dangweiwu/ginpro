import { RouteLocationNormalized, RouteRecordRaw } from 'vue-router';
import { useMyStore } from '@/store';


export default function usePermission() {
  const userStore = useMyStore();
  return {
    accessRouter(route: RouteLocationNormalized | RouteRecordRaw) {
      const userStore = useMyStore();
      if(!route.meta?.requiresAuth){
        return true
      }
      if(userStore.is_super_admin == "1"){
        return true
      }
      if(userStore.auths?.includes(route.meta?.roles?.[0] || "")){
        return true
      }else{
        return false
      }
    },
    findFirstPermissionRoute(_routers: any, role = 'admin') {
      return null;
      const cloneRouters = [..._routers];
      while (cloneRouters.length) {
        const firstElement = cloneRouters.shift();
        if (
          firstElement?.meta?.roles?.find((el: string[]) => {
            return el.includes('*') || el.includes(role);
          })
        )
          return { name: firstElement.name };
        if (firstElement?.children) {
          cloneRouters.push(...firstElement.children);
        }
      }
      return null;
    },
    // You can add any rules you want
  };
}
