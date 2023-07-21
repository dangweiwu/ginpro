<template>
    <div>
        <a-drawer v-model:visible="proxy" :width="1000" @ok="handleOk" @cancel="handleCancel" unmountOnClose
            popup-container="#rolebox">
            <template #title>
                {{ title }} 权限设置
            </template>
            <div>
                <a-row style="margin-bottom: 16px">
                    <a-col :span="24"
                        style="display: flex; align-items: flex-end; justify-content: end;height: 32px; padding-right: 14px;">

                        <a-tooltip :content="isFold ? '折叠' : '展开'">
                            <div class="action-icon" @click="fold">
                                <icon-double-up v-if="isFold" size="18" />
                                <icon-double-down v-else size="18" />
                            </div>
                        </a-tooltip>
                        <a-dropdown @select="handleSelectDensity">
                            <a-tooltip content="密度">
                                <div class="action-icon"><icon-line-height size="18" /></div>
                            </a-tooltip>
                            <template #content>
                                <a-doption v-for="item in densityList" :key="item.value" :value="item.value"
                                    :class="{ active: item.value === size }">
                                    <span>{{ item.name }}</span>
                                </a-doption>
                            </template>
                        </a-dropdown>
                    </a-col>
                </a-row>
                <!-- v-model:expandedKeys="expandedKeys"  -->
                <a-table row-key="code" :loading="loading" :columns="columns" :data="renderData" :bordered="false"
                    :size="size" :hide-expand-button-on-empty="true" ref="tableRef2" :pagination="false"
                    v-model:selectedKeys="expandedKeys" :row-selection="rowSelection">

                    <template #kind="{ record }">
                        <a-tag color="orange" v-if="record.kind == '0'"> API </a-tag>
                        <a-tag color="arcoblue" v-else> 菜单 </a-tag>
                    </template>
                </a-table>

            </div>

            <div>

            </div>
        </a-drawer>
    </div>
</template> 

<script  lang="ts" setup>
import { ref, computed, reactive, onMounted } from 'vue';
import useLoading from '@/hooks/loading';
import { apiRoleAuth } from '@/api/role';
import { Message } from '@arco-design/web-vue';
import { apiAuths } from '@/api/auths';
import { List } from 'echarts';

const props = defineProps({
    'modelValue': Boolean,
    'reload': Function,
    'data': Object,
});
const emit = defineEmits();

const id = ref("")
const title = ref("")
const proxy = computed({
    get: () => {
        if (props.modelValue == true) {
            // form.value = baseForm();
            fetchData().then(() => {
                tableRef2.value.expandAll(isFold.value)
            });
            console.log("props.data:", props.data)
            title.value = props.data?.name
            expandedKeys.value = props.data?.list
            id.value = props.data?.id
            // console.log("====", expandedKeys.value)

        }
        return props.modelValue
    },
    set: val => {
        emit('update:modelValue', val)
    }
})



const handleCancel = function () { }

//展开折叠
const isFold = ref(true)
const tableRef2 = ref()

const fold = function () {
    isFold.value = !isFold.value
    tableRef2.value.expandAll(isFold.value)
}
// onMounted(() => {
//     tableRef2.value.expandAll(isFold.value)
// })

//表格
//- 表格 尺寸
type SizeProps = 'mini' | 'small' | 'medium' | 'large';
const size = ref('medium');

const densityList = computed(() => [
    {
        name: '迷你',
        value: 'mini',
    },
    {
        name: '偏小',
        value: 'small',
    },
    {
        name: '中等',
        value: 'medium',
    },
    {
        name: '偏大',
        value: 'large',
    },
]);

const handleSelectDensity = (
    val: string | number | Record<string, any> | undefined,
    e: Event
) => {
    size.value = val as SizeProps;
};

const columns = computed(() => [
    {
        title: '#',
        dataIndex: 'index',
        slotName: 'index',
    },
    {
        title: '序号',
        dataIndex: 'order_num',
        slotName: 'order_num',
    },
    {
        title: '名称',
        dataIndex: 'name',
        slotName: 'name',
    },
    {
        title: '编码',
        dataIndex: 'code',
        slotName: 'code',
    },
    {
        title: 'API',
        dataIndex: 'api',
        slotName: 'api',
    },
    {
        title: '请求方式',
        dataIndex: 'method',
        slotName: 'method',
    },
    {
        title: '类型',
        dataIndex: 'kind',
        slotName: 'kind',
    },
]);

const { loading, setLoading } = useLoading(false);
const renderData = ref([]);
const fetchData = async () => {
    setLoading(true);
    try {
        const data = await apiAuths();
        renderData.value = data.data;
    } catch (err) {
        renderData.value = [];
    } finally {
        setLoading(false);
    }
};


//选择处理
const expandedKeys = ref([]);

const rowSelection = reactive({
    type: 'checkbox',
    showCheckedAll: false,
    checkStrictly: true
});


const handleOk = async function () {
    console.log("选中", expandedKeys.value)

    try {
        setLoading(true);
        let r = await apiRoleAuth(id.value, { "auth": expandedKeys.value })
        proxy.value = false
        props.reload()
        Message.success('设置成功');
    } catch (err) {
        console.log(err)
    } finally {
        setLoading(false);
    }

}
</script>

<style scoped lang="less">
.action-icon {
    margin-left: 12px;
    cursor: pointer;
}
</style>