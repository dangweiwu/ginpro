<template>
    <div>
        <a-modal v-model:visible="proxy" title="更新" title-align="start" :align-center="false" :top="200">
            <div>
                <a-form ref="formRef" :model="form" :label-col-props="{ span: 4 }">
                    <a-form-item field="name" label="姓 名" :rules="[
                        {
                            required: true,
                            message: '缺少姓名',
                        }
                    ]">
                        <a-input v-model="form.name" />
                    </a-form-item>
                    <a-form-item field="phone" label="手 机" :rules="[
                        {
                            validator: validatePhone,
                        }
                    ]">
                        <a-input v-model="form.phone" />
                    </a-form-item>
                    <a-form-item field="email" label="Email" :rules="[
                        {
                            validator: validateEmail,
                        }
                    ]">
                        <a-input v-model="form.email" />
                    </a-form-item>
                    <a-form-item field="status" label="状 态">
                        <a-radio-group v-model="form.status">
                            <a-radio value="0">禁用</a-radio>
                            <a-radio value="1">启用</a-radio>
                        </a-radio-group>
                    </a-form-item>
                    <a-form-item field="is_super_admin" label="管理员">
                        <a-radio-group v-model="form.is_super_admin">
                            <a-radio value="0">普通管理员</a-radio>
                            <a-radio value="1">超级管理员</a-radio>
                        </a-radio-group>
                    </a-form-item>

                    <a-form-item field="memo" label="备 注" :rules="[{
                        message: '长度不能200字符',
                        maxLength: 200,
                    }]">
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
import useLoading from '@/hooks/loading';
import { apiUpdateUser } from '@/api/users';
import { Message } from '@arco-design/web-vue';
const { loading, setLoading } = useLoading();
//show
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
// const handleOk = async () => {
//     await submit();
//     proxy.value = false;
// };
const handleCancel = () => {
    form.value = baseForm();
    proxy.value = false;
};

//数据
const id = ref(0);
const baseForm = function () {
    const _t = {
        phone: "",
        name: "",
        status: "0",
        memo: "",
        email: "",
        is_super_admin: "0",
    }
    id.value = props.data["id"]
    Object.keys(_t).map(function (key) {
        _t[key] = props.data[key]
    })

    return _t
}

const form = ref(baseForm())

//校验
const formRef = ref();

function isEmail(strEmail) {
    if (strEmail.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1)
        return true;
    else
        return false;
}
const validatePhone = (value, cb) => {

    if (String(value)?.length != 11) {
        cb('无效手机号');
    }
};

const validateEmail = (value, cb) => {
    if (value && !isEmail(value)) {
        cb('无效邮箱');
    }
};

//发送
const submit = async () => {

    const res = await formRef.value?.validate();
    if (res) {
        throw Error("invalid")
    }
    setLoading(true)
    try {
        await apiUpdateUser(form.value)
        Notification.success({ title: "修改成功", content: "" })
        props.reload();
        proxy.value = false;
    } finally {
        setLoading(false)
    }
}

</script>