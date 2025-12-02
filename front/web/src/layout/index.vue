<template>
  <div :class="classObj" class="app-wrapper" :style="{ '--current-color': theme }">
    <div v-if="device === 'mobile' && sidebar.opened" class="drawer-bg" @click="handleClickOutside"/>
    <sidebar v-if="!sidebar.hide && !hiddenLayout" class="sidebar-container"/>
    <div :class="{ hasTagsView: needTagsView, sidebarHide: sidebar.hide,hiddenLayout:hiddenLayout }"
         class="main-container">
      <div :class="{ 'fixed-header': fixedHeader }" v-if="!hiddenLayout">
        <navbar @setLayout="setLayout"/>
        <tags-view v-if="needTagsView"/>
      </div>
      <div v-if="hiddenLayout" style="position: absolute;top: 20px;right: 20px;z-index: 999;cursor: pointer;">
        <svg-icon icon-class="exit-fullscreen" @click="toggle1"/>
      </div>
      <app-main/>
      <settings ref="settingRef"/>
    </div>
  </div>
</template>

<script setup>
import {useFullscreen, useWindowSize} from '@vueuse/core'
import Sidebar from './components/Sidebar/index.vue'
import {AppMain, Navbar, Settings, TagsView} from './components'
import useAppStore from "@/store/modules/app.js";

const appStore = useAppStore()
import useSettingsStore from '@/store/modules/settings'

const {isFullscreen, enter, exit, toggle} = useFullscreen()
const settingsStore = useSettingsStore()
const theme = computed(() => settingsStore.theme)
const sideTheme = computed(() => settingsStore.sideTheme)
const sidebar = computed(() => useAppStore().sidebar)
const device = computed(() => useAppStore().device)
const needTagsView = computed(() => settingsStore.tagsView)
const fixedHeader = computed(() => settingsStore.fixedHeader)
const hiddenLayout = computed(() => useAppStore().hiddenLayout)
const classObj = computed(() => ({
  hideSidebar: !sidebar.value.opened,
  openSidebar: sidebar.value.opened,
  withoutAnimation: sidebar.value.withoutAnimation,
  mobile: device.value === 'mobile'
}))

const {width, height} = useWindowSize()
const WIDTH = 992 // refer to Bootstrap's responsive design

watch(() => device.value, () => {
  if (device.value === 'mobile' && sidebar.value.opened) {
    useAppStore().closeSideBar({withoutAnimation: false})
  }
})

watchEffect(() => {
  if (width.value - 1 < WIDTH) {
    useAppStore().toggleDevice('mobile')
    useAppStore().closeSideBar({withoutAnimation: true})
  } else {
    useAppStore().toggleDevice('desktop')
  }
})

function handleClickOutside() {
  useAppStore().closeSideBar({withoutAnimation: false})
}

const settingRef = ref(null)

function setLayout() {
  settingRef.value.openSetting()
}

function toggle1() {
  exit()
  appStore.toggleLayoutHidden(false)
}
</script>

<style lang="scss" scoped>
@use "@/assets/styles/mixin.scss" as mix;
@use "@/assets/styles/variables.module.scss" as vars;

.hiddenLayout {
  margin-left: 0 !important;
}

.app-wrapper {
  @include mix.clearfix;
  position: relative;
  height: 100%;
  width: 100%;

  &.mobile.openSidebar {
    position: fixed;
    top: 0;
  }
}

.drawer-bg {
  background: #000;
  opacity: 0.3;
  width: 100%;
  top: 0;
  height: 100%;
  position: absolute;
  z-index: 999;
}

.fixed-header {
  position: fixed;
  top: 0;
  right: 0;
  z-index: 9;
  width: calc(100% - #{vars.$base-sidebar-width});
  transition: width 0.28s;
}

.hideSidebar .fixed-header {
  width: calc(100% - 54px);
}

.sidebarHide .fixed-header {
  width: 100%;
}

.mobile .fixed-header {
  width: 100%;
}
</style>