<template>
  <div>
    <svg-icon :icon-class="isFullscreen ? 'exit-fullscreen' : 'fullscreen'" @click="toggle1"/>
  </div>
</template>

<script setup>
import {useFullscreen} from '@vueuse/core'
import useAppStore from "@/store/modules/app.js";
const appStore = useAppStore()
const {isFullscreen, enter, exit, toggle} = useFullscreen()

function toggle1() {
  appStore.toggleLayoutHidden(true)
  toggle()
}
</script>

<style lang='scss' scoped>
.screenfull-svg {
  display: inline-block;
  cursor: pointer;
  fill: #5a5e66;
  width: 20px;
  height: 20px;
  vertical-align: 10px;
}
</style>