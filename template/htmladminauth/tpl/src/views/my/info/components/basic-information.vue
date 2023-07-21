<template>
    <div class="box">
        <a-form ref="formRef" :model="formData" class="form" :label-col-props="{ span: 8 }"
            :wrapper-col-props="{ span: 16 }">
            <a-form-item field="name" label="姓 名" :rules="[
                {
                    required: true,
                    message: '缺少姓名',
                },
            ]">
                <a-input v-model="formData.name" placeholder="姓名"> </a-input>
            </a-form-item>
            <a-form-item field="phone" label="手机号" :rules="[
                {
                    validator: validatePhone,
                },
            ]">
                <a-input v-model="formData.phone" placeholder="手机号"> </a-input>
            </a-form-item>

            <a-form-item field="email" label="Email" :rules="[
                {
                    validator: validateEmail,
                },
            ]">
                <a-input v-model="formData.email" placeholder="Email"> </a-input>
            </a-form-item>
            <a-form-item field="memo" label="备 注" :rules="[{
                message: '长度不能200字符',
                maxLength: 200,
            }]">
                <a-textarea v-model="formData.memo">
                </a-textarea>
            </a-form-item>
            <a-form-item>
                <a-space>
                    <a-button type="primary" @click="validate">
                        保存
                    </a-button>
                    <a-button type="secondary" @click="reset">
                        重置
                    </a-button>
                </a-space>
            </a-form-item>
        </a-form>
    </div>
</template>

<script setup>
//设定
import { ref, reactive, onMounted } from 'vue';
import { Message, Modal, Notification } from '@arco-design/web-vue';
import { useMyStore } from '@/store';
import { setinfo, myInfo } from '@/api/my';

function isEmail(strEmail) {
    if (strEmail.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1)
        return true;
    else
        return false;
}

//初始化
const userStore = useMyStore();
const formRef = ref();
const formData = reactive({
    name: userStore.name,
    phone: userStore.phone,
    email: userStore.email,
    memo: "",
});

onMounted(async () => {
    try {
        const res = await myInfo()
        formData.name = res.name
        formData.phone = res.phone
        formData.email = res.email
        formData.memo = res.memo
    } catch (err) {

    }
})

const validatePhone = (value, cb) => {
    if (value?.length != 11) {
        cb('无效手机号');
    }
};

const validateEmail = (value, cb) => {
    if (value && !isEmail(value)) {
        cb('无效邮箱');
    }
};

const validate = async () => {
    const res = await formRef.value?.validate();
    console.log("valid res:", res)
    if (res) {
        return
    }
    //数据发送

    try {
        await setinfo(formData);
        Notification.success({ title: "修改成功", content: "" });
        userStore.setInfo(formData);

    } catch (err) {
        console.log(err)
    }
};

const reset = async () => {
    await formRef.value?.resetFields();
};
</script>

<style scoped lang="less">
.box {
    padding-top: 30px;
}

.form {
    width: 540px;
    margin: 0 auto;
}
</style>
