<template>
  <div class="container">
    <Breadcrumb :items="['个人中心', '我的设置']" />
    <a-row style="margin-bottom: 16px">
      <a-col :span="24">
        <UserPanel />
      </a-col>
    </a-row>
    <a-row class="wrapper">
      <a-col :span="24">
        <a-tabs default-active-key="1" type="rounded">
          <a-tab-pane key="1" title="个人信息">
            <BasicInformation />
          </a-tab-pane>
          <a-tab-pane key="2" title="密码设置">
            <SecuritySettings />
          </a-tab-pane>
          <!-- <a-tab-pane key="3" :title="$t('userSetting.tab.certification')">
            <Certification />
          </a-tab-pane> -->
        </a-tabs>
      </a-col>
    </a-row>
  </div>
</template>

<script setup>
import UserPanel from './components/myinfo.vue';
import BasicInformation from './components/basic-information.vue';
import SecuritySettings from './components/security-settings.vue';
  // import Certification from './components/certification.vue';

</script>  
<script>

export default {
  name: 'myinfo',
};
</script>

<style scoped lang="less">
.container {
  padding: 0 20px 20px 20px;
}

.wrapper {
  padding: 20px 0 0 20px;
  min-height: 580px;
  background-color: var(--color-bg-2);
  border-radius: 4px;
}

:deep(.section-title) {
  margin-top: 0;
  margin-bottom: 16px;
  font-size: 14px;
}
</style>
