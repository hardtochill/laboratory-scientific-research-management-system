<template>
  <div class="portal">
    <!-- 顶部导航 -->
    <header class="header">
      <div class="header-inner">
        <div class="logo-area">
          <img src="@/assets/portal/BUCT.png" alt="北京化工大学" class="logo-img" />
        </div>
        <nav class="nav-menu">
          <a
            v-for="item in navItems"
            :key="item.id"
            :href="'#' + item.id"
            class="nav-item"
            :class="{ active: activeSection === item.id }"
            @click="onNavClick(item.id)"
          >{{ item.label }}</a>
        </nav>
        <div class="header-right">
          <el-button type="primary" class="login-btn" @click="goLogin">登录</el-button>
        </div>
      </div>
    </header>

    <!-- Banner 区域 -->
    <section class="banner">
      <div class="banner-bg" v-for="(bg, idx) in bannerBgs" :key="idx" :class="{ active: bannerIdx === idx }">
        <img :src="bg" alt="" />
      </div>
      <div class="banner-mask"></div>
      <div class="banner-overlay">
        <h1 class="banner-title">化工行业数智一体化科研团队</h1>
        <p class="banner-subtitle">
          聚焦石化化工行业数智一体化技术的研究与应用转化
        </p>
        <p class="banner-desc">
          依托系统仿真、机理模型与智能算法，打造涵盖工艺平稳、安全管控与仿真培训的综合解决方案
        </p>
      </div>
    </section>

    <!-- 关于我们 -->
    <section id="about" class="section about-section">
      <div class="section-inner">
        <h2 class="section-title">关于我们</h2>
        <div class="section-divider"></div>
        <div class="about-content">
          <div class="about-text">
            <p>
              化工行业数智一体化科研团队聚焦石化化工行业数智一体化技术的研究与应用转化，
              依托系统仿真、机理模型与智能算法，打造涵盖工艺平稳、安全管控与仿真培训的综合解决方案，
              培养高水平科研人才，产出具有影响力的科研成果。
            </p>
            <div class="about-stats">
              <div class="stat-item">
                <span class="stat-num">3</span>
                <span class="stat-label">导师</span>
              </div>
              <div class="stat-item">
                <span class="stat-num">2</span>
                <span class="stat-label">博士生</span>
              </div>
              <div class="stat-item">
                <span class="stat-num">22</span>
                <span class="stat-label">硕士生</span>
              </div>
              <div class="stat-item">
                <span class="stat-num">58</span>
                <span class="stat-label">已培养毕业生</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 核心研究方向 -->
    <section id="research" class="section research-section">
      <div class="section-inner">
        <h2 class="section-title">核心研究方向</h2>
        <div class="section-divider"></div>
        <div class="research-grid">
          <div class="research-card">
            <div class="research-icon">
              <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
              </svg>
            </div>
            <h3>化工智能运维</h3>
            <p>化工生产过程的智能控制与平稳性管理研究，依托动态工艺模型与多维度评价机制，解决传统过程控制中回路振荡、报警泛滥等影响操作效率和生产稳定性的难题</p>
          </div>
          <div class="research-card">
            <div class="research-icon">
              <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
              </svg>
            </div>
            <h3>化工安全</h3>
            <p>化工过程中故障诊断与安全风险管控研究，基于自动HAZOP分析与装置异常工况预警，解决被动式安全防范与运维滞后的技术瓶颈</p>
          </div>
          <div class="research-card">
            <div class="research-icon">
              <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
              </svg>
            </div>
            <h3>化工仿真</h3>
            <p>基于数字孪生与混合现实的工艺仿真及数字化工艺交付研究，解决高危场景实操演练难及传统工程交付价值转化率低的痛点</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 团队成果 -->
    <section id="achievements" class="section achievements-section">
      <div class="section-inner">
        <h2 class="section-title">团队成果</h2>
        <div class="section-divider"></div>
        <div class="achievements-grid">
          <div class="achievement-card">
            <div class="achievement-num">16</div>
            <div class="achievement-label">近3年核心期刊论文</div>
            <div class="achievement-detail">其中TOP期刊7篇</div>
          </div>
          <div class="achievement-card">
            <div class="achievement-num">11</div>
            <div class="achievement-label">近3年各类项目</div>
            <div class="achievement-detail">其中重点项目1项</div>
          </div>
          <div class="achievement-card">
            <div class="achievement-num">11</div>
            <div class="achievement-label">授权发明专利</div>
            <div class="achievement-detail">持续创新驱动</div>
          </div>
        </div>
        <div class="achievement-highlight">
          <p class="highlight-paper">
            <strong>代表性论文：</strong>Yang Yuan, Xinyi Tao, Kejin Huang, Haisheng Chen, Xing Qian, Liang Zhang,
            Multi-objective optimization and composition control of Sargent dividing-wall distillation columns.
            <em>Journal of Cleaner Production</em>, 2023, 423, 138637
          </p>
          <p class="highlight-project">
            <strong>重点项目：</strong>面向多目标的煤转化过程运行状态评估、预测与实时优化，2024YFB4105203，夏涛，2024
          </p>
        </div>
      </div>
    </section>

    <!-- 科研平台与资源 -->
    <section id="platform" class="section platform-section">
      <div class="section-inner">
        <h2 class="section-title">科研平台与资源</h2>
        <div class="section-divider"></div>
        <p class="platform-desc">
          拥有多套微缩装置等半实物仿真系统和虚拟作训系统；可参与省部级重点项目和企业横向项目
        </p>
        <div class="platform-images">
          <div class="platform-img-wrapper">
            <img src="@/assets/portal/lab1.jpg" alt="科研平台1" />
          </div>
          <div class="platform-img-wrapper">
            <img src="@/assets/portal/lab2.jpg" alt="科研平台2" />
          </div>
        </div>
      </div>
    </section>

    <!-- 团队成员 -->
    <section class="section team-section">
      <div class="section-inner">
        <h2 class="section-title">团队成员</h2>
        <div class="section-divider"></div>
        <div class="team-grid">
          <div class="team-card">
            <img src="@/assets/portal/xiatao.jpg" alt="夏涛" class="team-avatar" />
            <h3>夏涛</h3>
            <p class="team-title">研究员</p>
            <p class="team-edu">北京化工大学控制科学与工程专业博士</p>
            <div class="team-directions">
              <span class="direction-tag">化工智能运维</span>
              <span class="direction-tag">化工安全</span>
              <span class="direction-tag">化工仿真</span>
            </div>
            <p class="team-achievement">主持国家重点研发计划课题1项、重大横向项目3项；SCI论文3篇；发明专利5项</p>
          </div>
          <div class="team-card">
            <img src="@/assets/portal/chenhaisheng.jpg" alt="陈海胜" class="team-avatar" />
            <h3>陈海胜</h3>
            <p class="team-title">副教授</p>
            <p class="team-edu">北京化工大学控制科学与工程专业博士</p>
            <div class="team-directions">
              <span class="direction-tag">化工智能运维</span>
              <span class="direction-tag">化工安全</span>
              <span class="direction-tag">复杂化工过程设计与控制</span>
            </div>
            <p class="team-achievement">主持国家自然科学基金1项、省部级项目1项；SCI论文10余篇；发明专利3项</p>
          </div>
          <div class="team-card">
            <img src="@/assets/portal/yanyang.jpg" alt="苑杨" class="team-avatar" />
            <h3>苑杨</h3>
            <p class="team-title">副教授</p>
            <p class="team-edu">北京化工大学控制科学与工程专业博士，博士后</p>
            <div class="team-directions">
              <span class="direction-tag">化工智能运维</span>
              <span class="direction-tag">化工安全</span>
              <span class="direction-tag">复杂化工过程设计与控制</span>
            </div>
            <p class="team-achievement">主持省部级项目2项、企业横向项目2项；SCI论文20余篇；发明专利3项</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 人才培养与团队氛围 -->
    <section id="talent" class="section talent-section">
      <div class="section-inner">
        <h2 class="section-title">人才培养与团队氛围</h2>
        <div class="section-divider"></div>
        <div class="talent-grid">
          <div class="talent-card">
            <div class="talent-icon">
              <svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
              </svg>
            </div>
            <h3>培养模式</h3>
            <p>一对一导师指导，提供系统化科研训练（文献阅读、仿真/实验操作、论文撰写等）；支持参与学术会议、竞赛、交流访学等活动</p>
          </div>
          <div class="talent-card">
            <div class="talent-icon">
              <svg viewBox="0 0 24 24" width="40" height="40" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
            </div>
            <h3>团队氛围</h3>
            <p>严谨务实、开放包容、互助协作，不定期开展课题跟踪交流、学术分享，兼顾科研创新与个人成长</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 人才招聘 -->
    <section class="section recruit-section">
      <div class="recruit-bg" v-for="(bg, idx) in bannerBgs" :key="idx" :class="{ active: recruitIdx === idx }">
        <img :src="bg" alt="" />
      </div>
      <div class="recruit-mask"></div>
      <div class="recruit-overlay">
        <h2 class="recruit-title">引才聚智 · 逐梦未来</h2>
        <p class="recruit-desc">诚邀有志于化工数智化方向的优秀学子加入团队</p>
        <el-button type="primary" size="large" class="recruit-btn" @click="goLogin">进入系统</el-button>
      </div>
    </section>

    <!-- 联系我们 -->
    <section id="contact" class="section contact-section">
      <div class="section-inner">
        <h2 class="section-title">联系我们</h2>
        <div class="section-divider"></div>
        <div class="contact-grid">
          <div class="contact-item">
            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            <span>联系人：陈海胜</span>
          </div>
          <div class="contact-item">
            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
            </svg>
            <span>邮箱：chenhs@mail.buct.edu.cn</span>
          </div>
          <div class="contact-item">
            <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.5">
              <path d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
              <path d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
            <span>地址：北京化工大学科技大厦413室</span>
          </div>
        </div>
      </div>
    </section>

    <!-- 底部 -->
    <footer class="footer">
      <div class="footer-inner">
        <p>© 2024 化工行业数智一体化科研团队 · 北京化工大学</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import bg1 from '@/assets/portal/background1.jpg'
import bg2 from '@/assets/portal/background2.jpg'
import bg3 from '@/assets/portal/background3.jpg'

const router = useRouter()

const bannerBgs = [bg1, bg2, bg3]
const bannerIdx = ref(0)
const recruitIdx = ref(1)
let bannerTimer = null
let recruitTimer = null

const navItems = [
  { id: 'about', label: '关于我们' },
  { id: 'research', label: '科学研究' },
  { id: 'achievements', label: '团队成果' },
  { id: 'platform', label: '科研平台' },
  { id: 'talent', label: '人才培养' },
  { id: 'contact', label: '联系我们' },
]

const activeSection = ref('about')
let scrollLock = false
let scrollTimer = null

function onNavClick(id) {
  activeSection.value = id
  scrollLock = true
  clearTimeout(scrollTimer)
  scrollTimer = setTimeout(() => { scrollLock = false }, 800)
}

function onScroll() {
  if (scrollLock) return
  const scrollTop = window.scrollY
  const windowHeight = window.innerHeight
  const docHeight = document.documentElement.scrollHeight
  if (scrollTop + windowHeight >= docHeight - 2) {
    activeSection.value = navItems[navItems.length - 1].id
    return
  }
  const offset = 120
  for (let i = navItems.length - 1; i >= 0; i--) {
    const el = document.getElementById(navItems[i].id)
    if (el && el.getBoundingClientRect().top <= offset) {
      activeSection.value = navItems[i].id
      return
    }
  }
  activeSection.value = navItems[0].id
}

onMounted(() => {
  window.addEventListener('scroll', onScroll, { passive: true })
  bannerTimer = setInterval(() => {
    bannerIdx.value = (bannerIdx.value + 1) % bannerBgs.length
  }, 5000)
  recruitTimer = setInterval(() => {
    recruitIdx.value = (recruitIdx.value + 1) % bannerBgs.length
  }, 6000)
})

onUnmounted(() => {
  window.removeEventListener('scroll', onScroll)
  clearInterval(bannerTimer)
  clearInterval(recruitTimer)
})

function goLogin() {
  router.push('/login')
}
</script>

<style lang="scss" scoped>
.portal {
  font-family: 'PingFang SC', 'Microsoft YaHei', 'Helvetica Neue', Arial, sans-serif;
  color: #333;
  background: #fff;
  min-height: 100vh;
}

/* 顶部导航 */
.header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(12px);
  box-shadow: 0 1px 8px rgba(0, 0, 0, 0.06);
  height: 72px;
}

.header-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 32px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
}

.logo-area {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-img {
  height: 48px;
  object-fit: contain;
}

.nav-menu {
  display: flex;
  gap: 8px;
}

.nav-item {
  padding: 8px 16px;
  font-size: 15px;
  color: #444;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.25s;
  white-space: nowrap;

  &:hover,
  &.active {
    color: #1a3c6e;
    background: rgba(26, 60, 110, 0.06);
  }
}

.header-right {
  display: flex;
  align-items: center;
}

.login-btn {
  border-radius: 20px;
  padding: 8px 28px;
  font-size: 15px;
  font-weight: 600;
  background: #1a3c6e;
  border: none;

  &:hover {
    background: #15325c;
  }
}

/* Banner */
.banner {
  margin-top: 72px;
  height: 520px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.banner-bg {
  position: absolute;
  inset: 0;
  opacity: 0;
  transition: opacity 1.2s ease-in-out;

  &.active {
    opacity: 1;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.banner-mask {
  position: absolute;
  inset: 0;
  background: rgba(13, 33, 55, 0.55);
  z-index: 1;
}

.banner-overlay {
  text-align: center;
  position: relative;
  z-index: 2;
  padding: 0 32px;
}

.banner-title {
  font-size: 42px;
  font-weight: 800;
  color: #fff;
  letter-spacing: 4px;
  margin-bottom: 20px;
}

.banner-subtitle {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.85);
  margin-bottom: 12px;
}

.banner-desc {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.6);
  max-width: 700px;
  margin: 0 auto;
  line-height: 1.8;
}

/* 通用 Section */
.section {
  padding: 80px 0;
}

.section-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 32px;
}

.section-title {
  font-size: 32px;
  font-weight: 700;
  color: #1a3c6e;
  text-align: center;
  margin-bottom: 12px;
}

.section-divider {
  width: 60px;
  height: 4px;
  background: linear-gradient(90deg, #1a3c6e, #2d6cbc);
  border-radius: 2px;
  margin: 0 auto 48px;
}

/* 关于我们 */
.about-section {
  background: #f8fafd;
}

.about-text p {
  font-size: 17px;
  line-height: 2;
  color: #555;
  text-align: center;
  max-width: 900px;
  margin: 0 auto 40px;
}

.about-stats {
  display: flex;
  justify-content: center;
  gap: 60px;
  flex-wrap: wrap;
}

.stat-item {
  text-align: center;
}

.stat-num {
  display: block;
  font-size: 48px;
  font-weight: 800;
  color: #1a3c6e;
  line-height: 1.2;
}

.stat-label {
  font-size: 15px;
  color: #888;
  margin-top: 4px;
}

/* 研究方向 */
.research-section {
  background: #fff;
}

.research-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
}

.research-card {
  background: #f8fafd;
  border-radius: 16px;
  padding: 40px 32px;
  text-align: center;
  transition: all 0.3s;
  border: 1px solid transparent;

  &:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 40px rgba(26, 60, 110, 0.1);
    border-color: rgba(26, 60, 110, 0.12);
  }

  h3 {
    font-size: 20px;
    font-weight: 700;
    color: #1a3c6e;
    margin: 20px 0 16px;
  }

  p {
    font-size: 14px;
    color: #666;
    line-height: 1.8;
  }
}

.research-icon {
  color: #2d6cbc;
}

/* 团队成果 */
.achievements-section {
  background: #f8fafd;
}

.achievements-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  margin-bottom: 48px;
}

.achievement-card {
  background: #fff;
  border-radius: 16px;
  padding: 40px 24px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}

.achievement-num {
  font-size: 56px;
  font-weight: 800;
  color: #1a3c6e;
  line-height: 1;
}

.achievement-label {
  font-size: 16px;
  color: #555;
  margin: 12px 0 8px;
  font-weight: 600;
}

.achievement-detail {
  font-size: 13px;
  color: #999;
}

.achievement-highlight {
  background: #fff;
  border-radius: 16px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
}

.highlight-paper,
.highlight-project {
  font-size: 15px;
  line-height: 1.8;
  color: #555;
  margin-bottom: 12px;

  strong {
    color: #1a3c6e;
  }

  em {
    color: #2d6cbc;
    font-style: italic;
  }
}

/* 科研平台 */
.platform-section {
  background: #fff;
}

.platform-desc {
  font-size: 17px;
  color: #555;
  text-align: center;
  line-height: 2;
  margin-bottom: 40px;
}

.platform-images {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
}

.platform-img-wrapper {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);

  img {
    width: 100%;
    height: 280px;
    object-fit: cover;
    display: block;
    transition: transform 0.4s;

    &:hover {
      transform: scale(1.03);
    }
  }
}

/* 团队成员 */
.team-section {
  background: #f8fafd;
}

.team-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
}

.team-card {
  background: #fff;
  border-radius: 16px;
  padding: 36px 28px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
  transition: all 0.3s;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 32px rgba(26, 60, 110, 0.1);
  }

  h3 {
    font-size: 22px;
    font-weight: 700;
    color: #1a3c6e;
    margin: 16px 0 8px;
  }
}

.team-avatar {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
  margin: 0 auto;
  border: 3px solid #e8edf4;
  box-shadow: 0 2px 12px rgba(26, 60, 110, 0.1);
}

.team-title {
  font-size: 15px;
  color: #2d6cbc;
  font-weight: 600;
  margin-bottom: 6px;
}

.team-edu {
  font-size: 13px;
  color: #999;
  margin-bottom: 12px;
}

.team-directions {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 6px;
  margin-bottom: 16px;
}

.direction-tag {
  font-size: 12px;
  padding: 4px 10px;
  background: rgba(26, 60, 110, 0.06);
  color: #1a3c6e;
  border-radius: 20px;
}

.team-achievement {
  font-size: 13px;
  color: #777;
  line-height: 1.6;
}

/* 人才培养 */
.talent-section {
  background: #fff;
}

.talent-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 32px;
}

.talent-card {
  background: #f8fafd;
  border-radius: 16px;
  padding: 40px 32px;
  text-align: center;
  transition: all 0.3s;

  &:hover {
    box-shadow: 0 8px 32px rgba(26, 60, 110, 0.08);
  }

  h3 {
    font-size: 20px;
    font-weight: 700;
    color: #1a3c6e;
    margin: 16px 0 12px;
  }

  p {
    font-size: 15px;
    color: #666;
    line-height: 1.8;
  }
}

.talent-icon {
  color: #2d6cbc;
}

/* 人才招聘 */
.recruit-section {
  padding: 0;
  height: 320px;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.recruit-bg {
  position: absolute;
  inset: 0;
  opacity: 0;
  transition: opacity 1.2s ease-in-out;

  &.active {
    opacity: 1;
  }

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }
}

.recruit-mask {
  position: absolute;
  inset: 0;
  background: rgba(13, 33, 55, 0.6);
  z-index: 1;
}

.recruit-overlay {
  text-align: center;
  position: relative;
  z-index: 2;
}

.recruit-title {
  font-size: 36px;
  font-weight: 800;
  color: #fff;
  letter-spacing: 6px;
  margin-bottom: 16px;
}

.recruit-desc {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.7);
  margin-bottom: 32px;
}

.recruit-btn {
  border-radius: 24px;
  padding: 12px 40px;
  font-size: 16px;
  font-weight: 600;
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.5);
  color: #fff;

  &:hover {
    background: rgba(255, 255, 255, 0.25);
    border-color: #fff;
  }
}

/* 联系我们 */
.contact-section {
  background: #f8fafd;
}

.contact-grid {
  display: flex;
  justify-content: center;
  gap: 48px;
  flex-wrap: wrap;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 16px;
  color: #555;

  svg {
    color: #2d6cbc;
    flex-shrink: 0;
  }
}

/* 底部 */
.footer {
  background: #0d2137;
  padding: 32px 0;
}

.footer-inner {
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;

  p {
    color: rgba(255, 255, 255, 0.5);
    font-size: 14px;
  }
}

/* 响应式 */
@media (max-width: 960px) {
  .research-grid,
  .team-grid,
  .achievements-grid {
    grid-template-columns: 1fr;
  }

  .platform-images {
    grid-template-columns: 1fr;
  }

  .nav-menu {
    display: none;
  }

  .banner-title {
    font-size: 28px;
  }
}
</style>
