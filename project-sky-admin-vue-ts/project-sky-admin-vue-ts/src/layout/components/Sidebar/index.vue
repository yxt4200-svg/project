<template>
  <div>
    <div class="logo">
      <div v-if="!isCollapse"
           class="sidebar-logo">
        <img src="@/assets/logo.png" class="logo-icon" alt="智慧校园外卖" />
        <span class="logo-text">智慧校园外卖</span>
      </div>
      <div v-else
           class="sidebar-logo-mini">
        <span class="logo-icon-mini">🍱</span>
      </div>
    </div>
    <el-scrollbar wrap-class="scrollbar-wrapper">
      <el-menu :default-openeds="defOpen"
               :default-active="defAct"
               :collapse="isCollapse"
               :background-color="variables.menuBg"
               :text-color="variables.menuText"
               :active-text-color="variables.menuActiveText"
               :unique-opened="false"
               :collapse-transition="false"
               mode="vertical">
        <sidebar-item v-for="route in routes"
                      :key="route.path"
                      :item="route"
                      :base-path="route.path"
                      :is-collapse="isCollapse" />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator'
import { AppModule } from '@/store/modules/app'
import { UserModule } from '@/store/modules/user'
import SidebarItem from './SidebarItem.vue'
import variables from '@/styles/_variables.scss'
import { getSidebarStatus, setSidebarStatus } from '@/utils/cookies'
import Cookies from 'js-cookie'
@Component({
  name: 'SideBar',
  components: {
    SidebarItem
  }
})
export default class extends Vue {
  private restKey: number = 0
  get name() {
    return (UserModule.userInfo as any).name
      ? (UserModule.userInfo as any).name
      : JSON.parse(Cookies.get('user_info') as any).name
  }
  get defOpen() {
    let path = ['/']
    this.routes.forEach((n: any, i: number) => {
      if (n.meta.roles && n.meta.roles[0] === this.roles[0]) {
        path.splice(0, 1, n.path)
      }
    })
    return path
  }

  get defAct() {
    let path = this.$route.path
    return path
  }

  get sidebar() {
    return AppModule.sidebar
  }

  get roles() {
    return UserModule.roles
  }

  get routes() {
    let routes = JSON.parse(
      JSON.stringify([...(this.$router as any).options.routes])
    )
    console.log('-=-=routes=-=-=', routes)
    console.log('-=-=routes=-=-=', this.roles[0])
    let menuList = []
    let menu = routes.find(item => item.path === '/')
    if (menu) {
      menuList = menu.children
    }
    console.log('-=-=routes=-wwww=-=', routes)
    return menuList
  }

  get variables() {
    return variables
  }

  get isCollapse() {
    return !this.sidebar.opened
  }
  private async logout() {
    this.$store.dispatch('LogOut').then(() => {
      this.$router.replace({ path: '/login' })
    })
  }
}
</script>

<style lang="scss" scoped>
.logo {
  text-align: center;
  // 修改：白色背景 + 蓝色底边
  background: #ffffff;
  border-bottom: 3px solid #4FACFE;
  padding: 15px 0 0;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  
  img {
    display: inline-block;
  }
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 8px;
  
  .logo-icon {
  width: 32px;
  height: 32px;
  margin-right: 8px;
  object-fit: contain;
}
  
  .logo-text {
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 1px;
}
}

.sidebar-logo-mini {
  .logo-icon-mini {
    width: 28px;
  height: 28px;
  object-fit: contain;
  }
}
.el-scrollbar {
  height: 100%;
  // 修改：浅蓝灰色背景
  background-color: #f8fafb;
}

.el-menu {
  border: none;
  height: calc(95vh - 23px);
  width: 100% !important;
  padding: 47px 15px 0;
}
</style>
