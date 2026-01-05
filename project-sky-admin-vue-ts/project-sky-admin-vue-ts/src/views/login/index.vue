<template>
  <div class="login">
    <div class="login-box">
      <div class="login-form">
        <el-form ref="loginForm" :model="loginForm" :rules="loginRules">
          <div class="login-form-title">
            <img src="@/assets/logo.png" class="logo-image" alt="智慧校园外卖" />
            <span class="title-label">智慧校园外卖</span>
            <span class="subtitle">Smart Campus Delivery</span>
          </div>
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              type="text"
              auto-complete="off"
              placeholder="请输入账号"
              prefix-icon="iconfont icon-user"
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              prefix-icon="iconfont icon-lock"
              @keyup.enter.native="handleLogin"
            />
          </el-form-item>
          <el-form-item style="width: 100%">
            <el-button
              :loading="loading"
              class="login-btn"
              size="medium"
              type="primary"
              style="width: 100%"
              @click.native.prevent="handleLogin"
            >
              <span v-if="!loading">登 录</span>
              <span v-else>登录中...</span>
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator'
import { Route } from 'vue-router'
import { Form as ElForm, Input } from 'element-ui'
import { UserModule } from '@/store/modules/user'
import { isValidUsername } from '@/utils/validate'

@Component({
  name: 'Login',
})
export default class extends Vue {
  private validateUsername = (rule: any, value: string, callback: Function) => {
    if (!value) {
      callback(new Error('请输入用户名'))
    } else {
      callback()
    }
  }
  private validatePassword = (rule: any, value: string, callback: Function) => {
    if (value.length < 6) {
      callback(new Error('密码必须在6位以上'))
    } else {
      callback()
    }
  }
  private loginForm = {
    username: 'admin',
    password: '123456',
  } as {
    username: String
    password: String
  }

  loginRules = {
    username: [{ validator: this.validateUsername, trigger: 'blur' }],
    password: [{ validator: this.validatePassword, trigger: 'blur' }],
  }
  private loading = false
  private redirect?: string

  @Watch('$route', { immediate: true })
  private onRouteChange(route: Route) {}

  // 登录
  private handleLogin() {
    ;(this.$refs.loginForm as ElForm).validate(async (valid: boolean) => {
      if (valid) {
        this.loading = true
        await UserModule.Login(this.loginForm as any)
          .then((res: any) => {
            if (String(res.code) === '1') {
              this.$router.push('/')
            } else {
              this.loading = false
            }
          })
          .catch(() => {
            this.loading = false
          })
      } else {
        return false
      }
    })
  }
}
</script>

<style lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  position: relative;
  overflow: hidden;
}

/* 添加装饰性背景圆圈 */
.login::before {
  content: '';
  position: absolute;
  width: 400px;
  height: 400px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  top: -100px;
  right: -100px;
}

.login::after {
  content: '';
  position: absolute;
  width: 300px;
  height: 300px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  bottom: -50px;
  left: -50px;
}

.login-box {
  width: 420px;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  padding: 50px 40px;
  position: relative;
  z-index: 1;
  transition: transform 0.3s ease;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.35);
  }
}

.title {
  margin: 0px auto 10px auto;
  text-align: left;
  color: #707070;
}

.login-form {
  background: transparent;
  width: 100%;
  border-radius: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  
  .el-form {
    width: 100%;
    height: auto;
  }
  
  .el-form-item {
    margin-bottom: 25px;
  }
  
  .el-form-item.is-error .el-input__inner {
    border: 2px solid #fd7065 !important;
    background: #fff !important;
  }
  
  .input-icon {
    height: 32px;
    width: 18px;
    margin-left: -2px;
  }
  
  .el-input__inner {
    border: 2px solid #e8ecf4;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 400;
    color: #333333;
    height: 48px;
    line-height: 48px;
    padding-left: 45px;
    transition: all 0.3s ease;
    
    &:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
  }
  
  .el-input__prefix {
    left: 15px;
    font-size: 18px;
    color: #667eea;
  }
  
  .el-input--prefix .el-input__inner {
    padding-left: 45px;
  }
  
  .el-input__inner::placeholder {
    color: #aeb5c4;
  }
  
  .el-form-item--medium .el-form-item__content {
    line-height: 48px;
  }
  
  .el-input--medium .el-input__icon {
    line-height: 48px;
  }
}

.login-btn {
  border-radius: 10px;
  padding: 14px 20px !important;
  margin-top: 20px;
  font-weight: 600;
  font-size: 16px;
  border: 0;
  color: #ffffff;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  transition: all 0.3s ease;
  
  &:hover,
  &:focus {
    background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
    color: #ffffff;
  }
  
  &:active {
    transform: translateY(0);
  }
}

.login-form-title {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-bottom: 45px;
  
  .logo-image {
    width: 80px;
    height: 80px;
    margin-bottom: 15px;
    animation: float 3s ease-in-out infinite;
    filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
  }
  
  .logo-icon {
    display: none !important;
  }
  
  .title-label {
    font-weight: 700;
    font-size: 26px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 8px;
    letter-spacing: 2px;
  }
  
  .subtitle {
    font-size: 12px;
    color: #999;
    font-weight: 400;
    letter-spacing: 1px;
    text-transform: uppercase;
  }
}

/* 添加浮动动画 */
@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}
</style>