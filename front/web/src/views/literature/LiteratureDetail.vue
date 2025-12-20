<template>
    <div class="app-container">
        <div style="text-align: center; padding: 50px;">
            <h3>文献详情页</h3>
            <p>该功能后续开发，当前仅提供空页面</p>
            <el-button type="primary" @click="goBack">返回列表</el-button>
        </div>
    </div>
</template>

<script setup name="LiteratureDetail">
import { useRouter, useRoute } from "vue-router"

const router = useRouter()
const route = useRoute()

/** 返回列表 */
function goBack() {
    router.push("/literature")
}
</script>

<style scoped>

</style>