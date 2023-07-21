import { createPinia } from 'pinia';
import useAppStore from './modules/app';
// import useUserStore from './modules/user';
import useMyStore from './modules/my';
import useTabBarStore from './modules/tab-bar';

const pinia = createPinia();

export { useMyStore,useAppStore, useTabBarStore };
export default pinia;
