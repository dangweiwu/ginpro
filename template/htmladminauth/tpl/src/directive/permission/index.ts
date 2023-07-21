import { DirectiveBinding } from 'vue';
import { useMyStore } from '@/store';

// function checkPermission(el: HTMLElement, binding: DirectiveBinding) {
//   const { value } = binding;
//   const userStore = useMyStore();
//   const { role } = userStore;

//   if (Array.isArray(value)) {
//     if (value.length > 0) {
//       const permissionValues = value;

//       const hasPermission = permissionValues.includes(role);
//       if (!hasPermission && el.parentNode) {
//         el.parentNode.removeChild(el);
//       }
//     }
//   } else {
//     throw new Error(`need roles! Like v-permission="['admin','user']"`);
//   }
// }

function checkPermission(el: HTMLElement, binding: DirectiveBinding) {
  const { value } = binding;
  const userStore = useMyStore();
  const { auth } = userStore;
  if(value){
    if(auth?.includes(value) === false){
      el?.parentNode?.removeChild(el);
    }

  }else{
    throw new Error(`need roles! Like v-permission="user"`);
  }


}

export default {
  mounted(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  },
  updated(el: HTMLElement, binding: DirectiveBinding) {
    checkPermission(el, binding);
  },
};
