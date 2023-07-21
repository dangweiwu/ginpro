<template>
  <div>
    <!--对话文档 https://arco.design/vue/component/modal-->
    <a-modal v-model:visible="proxy" title="新建" title-align="start" :align-center="false" :top="200">
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

          <a-form-item field="code" label="编码" :rules="[
            {
              required: true,
              message: '缺少权限编码',
            }
          ]">
            <a-input v-model="form.code" />

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

          <a-form-item field="kind" label="类型" :rules="[
            {
              required: true,
              message: '类型',
            }
          ]">
            <a-radio-group v-model="form.kind">
              <a-radio value="0">API</a-radio>
              <a-radio value="1">菜单</a-radio>
            </a-radio-group>
          </a-form-item>
          <a-form-item field="method" label="方法">
            <a-select v-model="form.method" :style="{ width: '400px' }" allow-clear>
              <a-option v-for="item of methodList" :value="item" :label="item" />
            </a-select>
          </a-form-item>
          <a-form-item field="api" label="API">
            <a-select v-model="form.api" :style="{ width: '400px' }" allow-clear>
              <a-option v-for="item of apiList" :value="item" :label="item" />
            </a-select>
          </a-form-item>



          <a-form-item field="parent_id" label="父类">

            <a-tree-select :data="authTreeData" v-model="authcode" :label-in-value="false" style="width: 400px"
              :allow-clear="true" :fieldNames="{
                key: 'code',
                title: 'name',
              }" default-value="">
              <template #label="{ data }">
                <a-tag color="orange" v-if="authTreeMap[data.value].kind == '0'"> API </a-tag>
                <a-tag color="arcoblue" v-else> 菜单 </a-tag> {{ data.label + " | " + data.value }}
              </template>
              <template #tree-slot-title="data">
                {{ data.name + '|' + data.code }}
              </template>

            </a-tree-select>

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
import { ref, computed, onMounted } from 'vue';
import useLoading from '@/hooks/loading';
import { apiCreateAuths, apiApiList, apiAuths } from '@/api/auths';
import { Message, Notification } from '@arco-design/web-vue';

const { loading, setLoading } = useLoading();

//数据
const authcode = ref("");

onMounted(() => {
  authcode.value = "";
})

const baseForm = function () {
  return {
    name: "",
    code: "",
    order_num: 0,
    api: "",
    method: "",
    kind: "",
    parent_id: 0,
  }
}

//show
const props = defineProps({
  'modelValue': Boolean,
  'reload': Function,
});
const emit = defineEmits();

const proxy = computed({
  get: () => {
    if (props.modelValue == true) {
      form.value = baseForm();
    }

    getApiTree();
    authcode.value = "";
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

//校验 eg
/*
const validatePhone = (value, cb) => {

  if (value && String(value)?.length != 11) {
    cb('无效手机号');
  }
};
*/



//发送
const submit = async () => {
  console.log("form:", form.value)

  const res = await formRef.value?.validate();
  if (res) {
    throw Error("invalid")
  }

  setLoading(true)
  try {
    //对tree parent_id 进行操作
    if (authcode.value) {
      let parent_id = authTreeMap.value[authcode.value].id;
      form.value.parent_id = parent_id;
    } else {
      form.value.parent_id = 0;
    }
    await apiCreateAuths(form.value)
    Notification.success({ title: "创建成功", content: "" })
    props.reload();
    proxy.value = false;
  } catch (err) {
    console.log(err)
  } finally {
    setLoading(false)
  }

}

const apiList = ref([])

onMounted(async () => {
  try {
    var r = await apiApiList()
    apiList.value = r.data
  } catch (err) {
    console.log(err)
  }
})


const methodList = ref(["GET", "POST", "PUT", "DELETE"])


const authTreeData = ref([])
const authTreeMap = ref({})


var getApiTree = async () => {
  try {
    var r = await apiAuths({ kind: "1" })
    authTreeData.value = r.data
    authTreeMap.value = {}
    var initAuthMap = function (data) {
      for (var item of data) {

        authTreeMap.value[item.code] = {
          id: item.id,
          name: item.name,
          kind: item.kind,
        }
        if (item.children) {
          initAuthMap(item.children)
        }
      }
    }
    initAuthMap(r.data)
    console.log("authMap", authTreeMap.value)

  } catch (err) {
    console.log(err)
  }
}

</script>