<template>
  <div class="home-container">
    <!-- 头部区域 -->
    <div class="home-header">
      <div class="header-content">
        <h1 class="system-title">欢迎使用 buct-tech</h1>
        <p class="system-subtitle">实验室科研管理系统</p>
        <p class="system-description">
          一个正在开发的实验管理平台，提供任务管理、文献管理、投稿管理等核心功能
        </p>
      </div>
    </div>

    <!-- 功能导航区域 -->
    <div class="home-nav">
      <div class="nav-content">
        <el-row :gutter="30">
          <el-col :xs="24" :sm="12" :md="8">
            <div class="nav-card" @click="navigateTo('/task')">
              <div class="card-icon task-icon">
                <svg-icon icon-class="task" />
              </div>
              <div class="card-content">
                <h3 class="card-title">任务管理</h3>
                <p class="card-description">创建、分配和跟踪实验任务</p>
              </div>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8">
            <div class="nav-card" @click="navigateTo('/literature/resource')">
              <div class="card-icon literature-icon">
                 <svg-icon icon-class="excel" />
              </div>
              <div class="card-content">
                <h3 class="card-title">文献管理</h3>
                <p class="card-description">上传、评分和评论实验文献</p>
              </div>
            </div>
          </el-col>
          <el-col :xs="24" :sm="12" :md="8">
            <div class="nav-card" @click="navigateTo('/submission/plan')">
              <div class="card-icon submission-icon">
                 <svg-icon icon-class="guide" />
              </div>
              <div class="card-content">
                <h3 class="card-title">投稿管理</h3>
                <p class="card-description">跟踪投稿进度和状态</p>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>

    <!-- 系统介绍区域 -->
    <div class="home-intro">
      <div class="intro-content">
        <h2 class="intro-title">系统功能</h2>
        <el-row :gutter="30">
          <el-col :xs="24" :md="8">
            <div class="intro-item">
              <h3 class="item-title">任务管理</h3>
              <ul class="item-list">
                <li>创建和分配实验任务</li>
                <li>跟踪任务进度和状态</li>
                <li>管理子任务和依赖关系</li>
                <li>任务完成情况统计</li>
              </ul>
            </div>
          </el-col>
          <el-col :xs="24" :md="8">
            <div class="intro-item">
              <h3 class="item-title">文献管理</h3>
              <ul class="item-list">
                <li>上传和管理文献</li>
                <li>文献关键词分类和搜索功能</li>
                <li>文献评分和评论</li>
                <li>文献下载阅读</li>
              </ul>
            </div>
          </el-col>
          <el-col :xs="24" :md="8">
            <div class="intro-item">
              <h3 class="item-title">投稿管理</h3>
              <ul class="item-list">
                <li>创建和管理投稿计划</li>
                <li>上传投稿相关文件</li>
                <li>跟踪投稿进度和状态</li>
                <li>记录多轮投稿文件</li>
              </ul>
            </div>
          </el-col>
        </el-row>
      </div>
    </div>

    <!-- 页脚区域 -->
    <div class="home-footer">
      <div class="footer-content">
        <p>buct-tech © 2026 实验室科研管理系统</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { Files, UploadFilled } from '@element-plus/icons-vue'
import SvgIcon from '@/components/SvgIcon'

const router = useRouter()

// 导航到指定页面
const navigateTo = (path) => {
  router.push(path)
}
</script>

<style scoped lang="scss">
.home-container {
  min-height: calc(100vh - 64px);
  display: flex;
  flex-direction: column;
}

// 头部样式
.home-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 60px 0;
  text-align: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 800px;
  margin: 0 auto;
}

.system-title {
  font-size: 3rem;
  margin-bottom: 10px;
  font-weight: 700;
}

.system-subtitle {
  font-size: 1.5rem;
  margin-bottom: 20px;
  opacity: 0.9;
}

.system-description {
  font-size: 1.1rem;
  line-height: 1.6;
  opacity: 0.8;
}

// 导航区域样式
.home-nav {
  padding: 60px 0;
  background-color: #f5f7fa;
}

.nav-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.nav-card {
  background: white;
  border-radius: 12px;
  padding: 30px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  cursor: pointer;
  text-align: center;
  border: 1px solid #ebeef5;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
  }
}

.card-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  font-size: 2.5rem;
  color: white;
}

.task-icon {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.literature-icon {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.submission-icon {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.card-title {
  font-size: 1.4rem;
  margin-bottom: 10px;
  color: #333;
}

.card-description {
  color: #666;
  font-size: 0.95rem;
  line-height: 1.5;
}

// 系统介绍区域样式
.home-intro {
  padding: 60px 0;
  background-color: white;
}

.intro-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.intro-title {
  text-align: center;
  font-size: 2rem;
  margin-bottom: 40px;
  color: #333;
}

.intro-item {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 30px;
  border: 1px solid #ebeef5;
}

.item-title {
  font-size: 1.3rem;
  margin-bottom: 20px;
  color: #333;
  display: flex;
  align-items: center;
}

.item-list {
  list-style: none;
  padding: 0;
}

.item-list li {
  padding: 8px 0;
  color: #666;
  position: relative;
  padding-left: 20px;

  &::before {
    content: "•";
    color: #667eea;
    font-weight: bold;
    position: absolute;
    left: 0;
  }
}

// 页脚样式
.home-footer {
  background-color: #333;
  color: white;
  padding: 30px 0;
  text-align: center;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

// 响应式设计
@media (max-width: 768px) {
  .system-title {
    font-size: 2rem;
  }

  .system-subtitle {
    font-size: 1.2rem;
  }

  .system-description {
    font-size: 1rem;
  }

  .home-header, .home-nav, .home-intro {
    padding: 40px 0;
  }

  .nav-card {
    padding: 20px 15px;
  }

  .card-icon {
    width: 60px;
    height: 60px;
    font-size: 2rem;
  }

  .intro-item {
    padding: 20px;
  }
}
</style>