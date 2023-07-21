<template>
  <div>
    <!--对话文档 https://arco.design/vue/component/modal-->
    <a-modal v-model:visible="proxy" title="更新" title-align="start" :align-center="false" :top="200">
      <div>
        <!-- form文档 https://arco.design/vue/component/form -->
        <a-form ref="formRef" :model="form" :label-col-props="{ span: 5 }">

          <!--eg
            1. 自定义校验
            <a-form-item field="phone" label="手 机" :rules="[{validator: validatePhone}]"><a-input v-model="form.phone" /></a-form-item>
            2. raido
            <a-form-item field="status" label="状 态">
              <a-radio-group v-model="form.status">
                <a-radio value="0">禁用</a-radio>
                <a-radio value="1">启用</a-radio>
              </a-radio-group>
            </a-form-item>
            3. textarea
            <a-form-item field="memo" label="备 注" :rules="[{message: '长度超过200字符',maxLength: 200}]">
              <a-textarea v-model="form.memo"></a-textarea>
            </a-form-item>
          -->
          <a-form-item field="name" label="名称" :rules="[{ required: true, message: '缺少名称' }]"><a-input
              v-model="form.name" /></a-form-item>
          <a-form-item field="order_num" label="排序" :rules="[{ required: true, message: '缺少排序' }]"><a-input-number
              v-model="form.order_num" :min="1" /></a-form-item>
          <a-form-item field="status" label="状 态" :rules="[{ required: true, message: '缺少状态' }]">
            <a-radio-group v-model="form.status">
              <a-radio value="0">禁用</a-radio>
              <a-radio value="1">启用</a-radio>
            </a-radio-group>
          </a-form-item>
          <a-form-item field="memo" label="备 注" :rules="[{ message: '长度超过200字符', maxLength: 200 }]">
            <a-textarea v-model="form.memo"></a-textarea>
          </a-form-item>
        </a-form>
      </div>
      <template #footer>
        <div>
          <a-space>
            <a-button @click="handleCancel">
              取消
            </a-button>
            <a-button type="primary" :loading="loading" @click="submit">
              确定
            </a-button>
          </a-space>
        </div>
      </template>
    </a-modal>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue';
import { apiUpdateRole } from '@/api/role';
import { Message, Notification } from '@arco-design/web-vue';
import useLoading from '@/hooks/loading';
const { loading, setLoading } = useLoading();
//show

//数据
const id = ref(0);
const baseForm = function () {
  const _t = {
    name: "",
    order_num: 0,
    status: "",
    memo: "",

  }
  id.value = props.data["id"]
  Object.keys(_t).map(function (key) {
    _t[key] = props.data[key]
  })
  return _t
}

const props = defineProps({
  'modelValue': Boolean,
  'reload': Function,
  'data': Object,
});
const emit = defineEmits();

const proxy = computed({
  get: () => {
    if (props.modelValue == true) {
      form.value = baseForm();
    }
    return props.modelValue
  },
  set: val => {
    emit('update:modelValue', val)
  }
})

//按钮
const handleCancel = () => {
  form.value = baseForm();
  proxy.value = false;
};



const form = ref(baseForm())

//校验
const formRef = ref();

/*eg
const validatePhone = (value, cb) => {

  if (String(value)?.length != 11) {
    cb('无效手机号');
  }
};
* */


//发送
const submit = async () => {
  const res = await formRef.value?.validate();
  if (res) {
    throw Error("invalid")
  }
  setLoading(true)
  try {
    await apiUpdateRole(id.value, form.value)
    Notification.success("修改成功")
    props.reload();
    proxy.value = false;
  } finally {
    setLoading(false)
  }
}

</script>