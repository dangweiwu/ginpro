<template>
  <a-card :bordered="false">
    <a-space :size="54">
      <a-descriptions :data="renderData" :column="2" align="right" layout="inline-horizontal" :label-style="{
        width: '140px',
        fontWeight: 'normal',
        color: 'rgb(var(--gray-8))',
      }" :value-style="{
  width: '200px',
  paddingLeft: '8px',
  textAlign: 'left',
}">
        <template #label="{ label }">{{ label }} :</template>
        <template #value="d">
          <span>{{ d.value }}</span>
        </template>
      </a-descriptions>

      <!-- {{ userStore.name }} -->
    </a-space>
  </a-card>
</template>
  
<script lang="ts" setup>

import { ref, computed } from 'vue'
import { useMyStore } from '@/store';


const userStore = useMyStore();
console.log("userStore", userStore.account)

const renderData = computed(() => {
  return [
    {
      label: '账号',
      value: userStore.account,
    },
    {
      label: '姓名',
      value: userStore.name,
    },
  ]
}
)


</script>
  
<style scoped lang="less">
.arco-card {
  padding: 14px 0 4px 4px;
  border-radius: 4px;
}

:deep(.arco-avatar-trigger-icon-button) {
  width: 32px;
  height: 32px;
  line-height: 32px;
  background-color: #e8f3ff;

  .arco-icon-camera {
    margin-top: 8px;
    color: rgb(var(--arcoblue-6));
    font-size: 14px;
  }
}
</style>
  