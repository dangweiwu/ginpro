<template>
    <div>
        <a-modal v-model:visible="proxy" title="新建" title-align="start" :align-center="false" :top="200">
            <div>
                <a-form ref="formRef" :model="form" :label-col-props="{ span: 4 }">
                    <a-form-item field="account" label="账 号" :rules="[
                        {
                            required: true,
                            message: '缺少账号',
                        }
                    ]">
                        <a-input v-model="form.account" />
                    </a-form-item>
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
                    <a-form-item field="password" label="密 码" :rules="[
                        {
                            required: true,
                            message: '缺少密码'
                        }, { message: '不少于6个字符', minLength: 6 }]">
                        <a-input v-model="form.password" />
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
                    <a-form-item field="role" label="角色">
                        <a-select :style="{ width: '400px' }" placeholder="" v-model="form.role" :options="props.roles"
                            :field-names="roleFieldName">
                        </a-select>
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
import { ref, computed, reactive, onMounted } from 'vue';
import useLoading from '@/hooks/loading';
import { apiCreateUser } from '@/api/users';
import { apiRole } from '@/api/role'
import { Message, Notification } from '@arco-design/web-vue';
const { loading, setLoading } = useLoading();
//show
const props = defineProps({
    'modelValue': Boolean,
    'reload': Function,
    'roles': Array,
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


const handleCancel = () => {
    form.value = baseForm();
    proxy.value = false;
};

//数据
const baseForm = function () {
    return {
        account: "",
        phone: "",
        name: "",
        status: "0",
        password: "",
        memo: "",
        email: "",
        is_super_admin: "0",
        role: "",
    }
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

    if (value && String(value)?.length != 11) {
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
        await apiCreateUser(form.value)
        Notification.success({ title: "创建成功", content: "" })
        props.reload();
        proxy.value = false;
    } finally {
        setLoading(false)
    }
}

//角色相关

const roleFieldName = { value: "code", label: "name" }



</script>