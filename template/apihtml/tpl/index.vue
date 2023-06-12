<!--文档地址 https://arco.design/vue/docs/pro/start-->
<!--xx按需替换-->
<template>
    <div class="container">
        <!--面包屑设置 文档 https://arco.design/vue/component/breadcrumb-->
        <Breadcrumb :items="['xxxx', 'xxxx']" />
        <!--搜索栏-->
        <a-card class="general-card" style="padding-top: 20px">
            <a-row>
                <a-col :flex="1">
                    <!-- 搜索部分 form文档 https://arco.design/vue/component/form -->
                    <a-form :model="queryForm" :label-col-props="{ span: 6 }" :wrapper-col-props="{ span: 18 }" label-align="right">
                        <a-row :gutter="16">
                            [[ range $k,$v := .QueryRule -]]
                            <a-col :span="6" >
                                <a-form-item field="[[$v.Key]]" label="[[$v.Name]]">
                                    <a-input v-model="queryForm.[[$v.Key]]" placeholder="[[$v.Name]]" />
                                </a-form-item>
                            </a-col>
                            [[ end ]]
                        </a-row>
                    </a-form>
                </a-col>
                <a-divider style="height: 33px" direction="vertical" />
                <!-- 按钮部分 -->
                <a-col flex="200px" style="text-align: right">
                    <a-space :size="18">
                        <a-button type="primary" @click="search">
                            <template #icon>
                                <icon-search />
                            </template>
                            查询
                        </a-button>
                        <a-button @click="reset">
                            <template #icon>
                                <icon-refresh />
                            </template>
                            重置
                        </a-button>
                    </a-space>
                </a-col>
            </a-row>
            <!--table 功能-->
            <a-divider style="margin-top: 0" />
            <a-row style="margin-bottom: 16px">
                <a-col :span="12">
                    <a-space>
                        <a-button type="primary" @click="addBtn = true">
                            <template #icon>
                                <icon-plus />
                            </template>
                            新建
                        </a-button>
                    </a-space>
                </a-col>
                <a-col :span="12" style="display: flex; align-items: flex-end; justify-content: end;height: 32px; padding-right: 14px;">
                    <a-tooltip content="刷新">
                        <div class="action-icon" @click="search"><icon-refresh size="18"/></div>
                    </a-tooltip>
                    <a-dropdown @select="handleSelectDensity">
                        <a-tooltip content="密度">
                            <div class="action-icon"><icon-line-height size="18" /></div>
                        </a-tooltip>
                        <template #content>
                            <a-doption v-for="item in densityList" :key="item.value" :value="item.value" :class="{ active: item.value === size }">
                                <span>{{ item.name }}</span>
                            </a-doption>
                        </template>
                    </a-dropdown>
                </a-col>
            </a-row>
            <!--表格部分-->
            <!--文档 https://arco.design/vue/component/table-->
            <a-table row-key="id" :loading="loading" :pagination="pagination" :columns="columns" :data="renderData" :bordered="false" :size="size" @page-change="onPageChange" @page-size-change="onPageSizeChange">
                <template #index="{ rowIndex }">
                    {{ rowIndex + 1 + (pagination.current - 1) * pagination.pageSize }}
                </template>

                <!---eg about radio
                <template #status="{ record }">
                    <a-tag color="arcoblue" v-if="record.status == '1'"> 启用 </a-tag>
                    <a-tag color="gray" v-else> 禁用 </a-tag>
                </template>
                --->
                <template #opt="{ record }">
                    <a-button-group type="text" :long="true" style="padding: 0px">
                        <a-button style="padding: 0 5px" @click="onInfo(record)">
                            详情
                        </a-button>
                        <a-button style="padding: 0 5px" @click="onUpdate(record)">
                            更新
                        </a-button>
                        <a-popconfirm
                                content="确定删除？"
                                position="tr"
                                @ok="onDel(record)"
                        >
                            <a-button style="padding: 0 5px"> 删除 </a-button>
                        </a-popconfirm>
                    </a-button-group>
                </template>
            </a-table>
        </a-card>

        <!--表格中的详情-->
        <!--对话文档 https://arco.design/vue/component/modal-->
        <a-modal v-model:visible="infoshow" title="详情" title-align="start" :align-center="false" :top="200" :width="800" :hide-cancel="true">
            <!--描述文档 https://arco.design/vue/component/descriptions-->
            <a-descriptions :data="infodata" bordered :column="2" table-layout="fixed" :label-style="{ width: '100px' }"
            />
        </a-modal>

        <!--新建组件-->
        <create-form v-model="addBtn" :reload="initSearch"></create-form>

        <!--更新组件-->
        <update-form v-model="updateBtn" :reload="fetchData" :data="updateData"></update-form>
    </div>
</template>

<script lang="ts" setup>
    import { computed, ref, reactive } from 'vue';
    import { useI18n } from 'vue-i18n';
    import useLoading from '@/hooks/loading';
    import { onMounted } from 'vue';
    import { Message } from '@arco-design/web-vue';
    //api导入
    import { api[[UpFirst .Name]], apiDel[[UpFirst .Name]] } from '@/api/[[.Name]]';
    import createForm from './create.vue';
    import updateForm from './update.vue';
    //多语言
    const { t } = useI18n();

    //搜索框
    const initQuerForm = () => {
        return {
            [[ range $k,$v :=.QueryRule -]]
                [[$v]] :  '',
            [[ end ]]

        };
    };
    const queryForm = ref(initQuerForm());

    const reset = () => {
        queryForm.value = initQuerForm();
    };

    //表格
    //- 表格 尺寸
    type SizeProps = 'mini' | 'small' | 'medium' | 'large';
    const size = ref('medium');

    const densityList = computed(() => [
        {
            name: t('searchTable.size.mini'),
            value: 'mini',
        },
        {
            name: t('searchTable.size.small'),
            value: 'small',
        },
        {
            name: t('searchTable.size.medium'),
            value: 'medium',
        },
        {
            name: t('searchTable.size.large'),
            value: 'large',
        },
    ]);

    const handleSelectDensity = (
        val: string | number | Record<string, any> | undefined,
        e: Event
    ) => {
        size.value = val as SizeProps;
    };
    // - 表格表头

    const columns = computed(() => [
        {
            title: '#',
            dataIndex: 'index',
            slotName: 'index',
        },
        [[ range $k,$v := .View -]]
        {
            title: '[[$v.Name]]',
            dataIndex:'[[$v.Key]]',
            slotName: '[[$v.Key]]',
        },
        [[ end ]]
        {
            title: '操作',
            slotName: 'opt',
            align: 'center',
        },
    ]);

    //分页及数据请求
    const { loading, setLoading } = useLoading(true);
    const renderData = ref([]);

    const pagination = reactive({
        total: 0,
        current: 1,
        pageSize: 20,
        showTotal: true,
        showPageSize: true,
        defaultPageSize: 20,
        pageSizeOptions: [10, 20, 30, 40, 50],
    });

    const fetchData = async () => {
        setLoading(true);
        try {

            const data = await api[[UpFirst .Name]]({
                current: pagination.current,
                limit: pagination.pageSize,
                ...queryForm.value,
            });
            renderData.value = data.data;
            pagination.current = data.page.current;
            pagination.total = data.page.total;
            pagination.pageSize = data.page.limit;
        } catch (err) {
            // you can report use errorHandler or other
            renderData.value = [];
        } finally {
            setLoading(false);
        }
    };

    const search = () => {
        pagination.current = 1;
        fetchData();
    };

    const initSearch = () => {
        pagination.current = 1;
        reset();
        fetchData();
    };

    const onPageChange = (current) => {
        pagination.current = current;
        fetchData();
    };

    const onPageSizeChange = (pageSize) => {
        pagination.current = 1;
        pagination.pageSize = pageSize;
        fetchData();
    };

    onMounted(() => {
        fetchData();
    });

    //详情
    const infoshow = ref(false);
    const infodata = ref([]);
    const onInfo = (data) => {
        infoshow.value = true;
        infodata.value = [
            [[range $k,$v:= .View -]]
            { label: '[[$v.Name]]',value: data.[[$v.Key]]},
            [[ end]]

        ];
    };

    //新建
    const addBtn = ref(false);

    //更新
    const updateData = ref({});
    const updateBtn = ref(false);
    const onUpdate = function (data) {
        updateBtn.value = true;
        updateData.value = data;
    };

    //删除
    const onDel = async function (record) {
        try {
            //Xxx替换api
            await apiDel[[UpFirst .Name]](record.id);
            Message.success('删除成功');
            fetchData();
        } catch (err) {}
        console.log('record', record);
    };
</script>

<script lang="ts">
    export default {
        name: 'SearchTable',
    };
</script>

<style scoped lang="less">
    .container {
        padding: 0 20px 20px 20px;
    }

    :deep(.arco-table-th) {
        &:last-child {
            .arco-table-th-item-title {
                margin-left: 16px;
            }
        }
    }

    .action-icon {
        margin-left: 12px;
        cursor: pointer;
    }

    .active {
        color: #0960bd;
        background-color: #e3f4fc;
    }

    .setting {
        display: flex;
        align-items: center;
        width: 200px;

        .title {
            margin-left: 12px;
            cursor: pointer;
        }
    }
</style>
