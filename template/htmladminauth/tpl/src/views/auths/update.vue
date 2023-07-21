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

          <a-form-item field="name" label="名称" :rules="[
            {
              required: true,
              message: '缺少权限名称',
            }
          ]">
            <a-input v-model="form.name" />

          </a-form-item>

          <a-form-item field="order_num" label="排序" :rules="[
            {
              required: true,
              message: '缺少排序',
            },
            { min: 1, message: '不能小于1' }
          ]">

            <a-input-number v-model="form.order_num" />
          </a-form-item>


          <template v-if="form.kind == '0'">
            <a-form-item field="method" label="方法">
              <a-select v-model="form.method" :style="{ width: '400px' }">
                <a-option v-for="item of methodList" :value="item" :label="item" />
              </a-select>
            </a-form-item>
            <a-form-item field="api" label="API">
              <a-select v-model="form.api" :style="{ width: '400px' }">
                <a-option v-for="item of apiList" :value="item" :label="item" />
              </a-select>
            </a-form-item>
          </template>


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
import { ref, computed, onMounted } from 'vue';
import { apiUpdateAuths, apiApiList } from '@/api/auths';
import { Message, Notification } from '@arco-design/web-vue';
import useLoading from '@/hooks/loading';

const { loading, setLoading } = useLoading();
//show

//数据
const id = ref(0);
const baseForm = function () {
  const _t = {
    name: "",
    kind: "0",
    order_num: 0,
    api: "",
    method: "",
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
      if (form.value.kind == '0') {
        apiApiList().then((res) => {
          apiList.value = res.data
        })

      }
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
    await apiUpdateAuths(id.value, form.value)
    Notification.success({ title: "修改成功", content: "" })
    props.reload();
    proxy.value = false;
  } finally {
    setLoading(false)
  }
}

const methodList = ref(["GET", "POST", "PUT", "DELETE"])

const apiList = ref([])
</script>