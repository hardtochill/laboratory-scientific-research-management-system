<template>
  <div class="container">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-header-logo">
          <img src="../assets/login/images/logo.png">
        </div>
        <h1 class="panel-header-title">buct-tech
        </h1>
      </div>
      <el-form class="form" ref="loginRef" :model="loginForm" :rules="loginRules">
        <div class="input">
          <i class="iconfont icon-RectangleCopy"></i>
          <input type="text" class="input-field" placeholder="请输入用户名" v-model="loginForm.username"/>
        </div>
        <div class="input">
          <i class="iconfont icon-RectangleCopy2"></i><input type="password" class="input-field"
                                                             placeholder="请输入密码"
                                                             v-model="loginForm.password" @keyup.enter="handleLogin" />
        </div>
        <div class="input">
          <i class="iconfont icon-RectangleCopy1"></i><input type="text" class="input-field" placeholder="请输入验证码"
                                                             v-model="loginForm.code" @keyup.enter="handleLogin"/><img
            :src="codeUrl" @click="getCode"></div>
        <div class="remember">
          <input type="checkbox" v-model="loginForm.rememberMe" name="" id="remember" value=""/><label for="remember">记住密码</label>
        </div>
        <el-button class="input-submit" @click.native.prevent="handleLogin">登录</el-button>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import '@/assets/login/css/style.css'
import '@/assets/login/font/iconfont.css'

import {getCodeImg} from "@/api/login"
import Cookies from "js-cookie"
import {encrypt, decrypt} from "@/utils/jsencrypt"
import useUserStore from '@/store/modules/user'

const title = import.meta.env.VITE_APP_TITLE
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const {proxy} = getCurrentInstance()

const loginForm = ref({
  username: "",
  password: "",
  rememberMe: false,
  code: "",
  uuid: ""
})

const loginRules = {
  username: [{required: true, trigger: "blur", message: "请输入您的账号"}],
  password: [{required: true, trigger: "blur", message: "请输入您的密码"}],
  code: [{required: true, trigger: "change", message: "请输入验证码"}]
}

const codeUrl = ref("")
const loading = ref(false)
// 验证码开关
const captchaEnabled = ref(true)
// 注册开关
const register = ref(false)
const redirect = ref(undefined)

watch(route, (newRoute) => {
  redirect.value = newRoute.query && newRoute.query.redirect
}, {immediate: true})

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true
      // 勾选了需要记住密码设置在 cookie 中设置记住用户名和密码
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, {expires: 30})
        Cookies.set("password", encrypt(loginForm.value.password), {expires: 30})
        Cookies.set("rememberMe", loginForm.value.rememberMe, {expires: 30})
      } else {
        // 否则移除
        Cookies.remove("username")
        Cookies.remove("password")
        Cookies.remove("rememberMe")
      }
      // 调用action的登录方法
      userStore.login(loginForm.value).then(() => {
        const query = route.query
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur]
          }
          return acc
        }, {})
        router.push({path: redirect.value || "/", query: otherQueryParams})
      }).catch(() => {
        loading.value = false
        // 重新获取验证码
        if (captchaEnabled.value) {
          getCode()
        }
      })
    }
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

getCode()
getCookie()
</script>

<style lang='scss' scoped>
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background.jpg");
  background-size: cover;
}

.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;

  .el-input {
    height: 40px;

    input {
      height: 40px;
    }
  }

  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
  }
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 33%;
  height: 40px;
  float: right;

  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.input-submit{
  background-color: #667eea;
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}

.login-code-img {
  height: 40px;
  padding-left: 12px;
}
</style>
