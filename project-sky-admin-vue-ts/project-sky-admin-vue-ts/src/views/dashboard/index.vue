<template>
  <div class="dashboard-container home">
    <!-- 页面标题 - 新设计 -->
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">📊</div>
        <div class="header-content">
          <h2 class="page-title">工作台概览</h2>
          <p class="page-subtitle">{{ currentDate }}</p>
        </div>
      </div>
      <div class="header-right">
        <el-button class="refresh-btn" icon="el-icon-refresh" circle></el-button>
      </div>
    </div>

    <!-- 营业数据 -->
    <Overview :overviewData="overviewData" />

    <!-- 订单管理 -->
    <Orderview :orderviewData="orderviewData" />

    <!-- 菜品和套餐总览 - 网格布局 -->
    <div class="statistics-grid">
      <!-- 菜品总览 -->
      <div class="stat-card">
        <CuisineStatistics :dishesData="dishesData" />
      </div>
      
      <!-- 套餐总览 -->
      <div class="stat-card">
        <SetMealStatistics :setMealData="setMealData" />
      </div>
    </div>

    <!-- 订单信息 -->
    <div class="order-list-section">
      <OrderList
        :order-statics="orderStatics"
        @getOrderListBy3Status="getOrderListBy3Status"
      />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import {
  getBusinessData,
  getDataOverView,
  getOrderData,
  getOverviewDishes,
  getSetMealStatistics,
} from '@/api/index'
import { getOrderListBy } from '@/api/order'
// 组件
import Overview from './components/overview.vue'
import Orderview from './components/orderview.vue'
import CuisineStatistics from './components/cuisineStatistics.vue'
import SetMealStatistics from './components/setMealStatistics.vue'
import OrderList from './components/orderList.vue'

@Component({
  name: 'Dashboard',
  components: {
    Overview,
    Orderview,
    CuisineStatistics,
    SetMealStatistics,
    OrderList,
  },
})
export default class extends Vue {
  private todayData = {} as any
  private overviewData = {}
  private orderviewData = {} as any
  private flag = 2
  private tateData = []
  private dishesData = {} as any
  private setMealData = {}
  private orderListData = []
  private counts = 0
  private page: number = 1
  private pageSize: number = 10
  private status = 2
  private orderStatics = {} as any

  // 获取当前日期
  get currentDate() {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    const weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
    const weekday = weekdays[now.getDay()]
    return `${year}年${month}月${day}日 ${weekday}`
  }

  get today() {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0')
    const day = String(now.getDate()).padStart(2, '0')
    return `${year}.${month}.${day}`
  }

  created() {
    this.init()
  }

  init() {
    this.$nextTick(() => {
      this.getBusinessData()
      this.getOrderStatisticsData()
      this.getOverStatisticsData()
      this.getSetMealStatisticsData()
    })
  }

  async getBusinessData() {
    const data = await getBusinessData()
    this.overviewData = data.data.data
  }

  async getOrderStatisticsData() {
    const data = await getOrderData()
    this.orderviewData = data.data.data
  }

  async getOverStatisticsData() {
    const data = await getOverviewDishes()
    this.dishesData = data.data.data
  }

  async getSetMealStatisticsData() {
    const data = await getSetMealStatistics()
    this.setMealData = data.data.data
  }

  getOrderListBy3Status() {
    getOrderListBy({})
      .then((res) => {
        if (res.data.code === 1) {
          this.orderStatics = res.data.data
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background: #f5f8fa;
  min-height: 100vh;

  // 页面头部 - 全新设计
  .page-header {
    margin-bottom: 24px;
    padding: 24px 28px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(102, 126, 234, 0.25);
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
      top: -50px;
      right: -50px;
    }

    .header-left {
      display: flex;
      align-items: center;
      gap: 16px;
      z-index: 1;
    }

    .header-icon {
      font-size: 48px;
      animation: float 3s ease-in-out infinite;
    }

    .header-content {
      .page-title {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
        color: #ffffff;
        margin-bottom: 4px;
      }

      .page-subtitle {
        margin: 0;
        font-size: 14px;
        color: rgba(255, 255, 255, 0.9);
      }
    }

    .header-right {
      z-index: 1;
      
      .refresh-btn {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: #ffffff;
        font-size: 18px;
        
        &:hover {
          background: rgba(255, 255, 255, 0.3);
        }
      }
    }
  }

  // 统计卡片网格
  .statistics-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
    margin-bottom: 24px;

    @media (max-width: 1200px) {
      grid-template-columns: 1fr;
    }
  }

  // 卡片样式
  .stat-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
    }
  }

  // 订单列表区域
  .order-list-section {
    background: #ffffff;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}
</style>

<style lang="scss">
// 全局样式优化
.home {
  // 修改所有黄色按钮为蓝色渐变
  .el-button--primary {
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    border: none;
    color: #ffffff;
    transition: all 0.3s ease;

    &:hover,
    &:focus {
      background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(79, 172, 254, 0.4);
    }
  }

  // 修改黄色卡片背景
  .el-card {
    border: none;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    
    &.is-always-shadow {
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    }
  }

  // 数据统计数字样式
  .stat-number {
    font-size: 32px;
    font-weight: 700;
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
  }

  // 状态颜色
  .status-warning {
    color: #ff9800;
  }

  .status-success {
    color: #4caf50;
  }

  .status-processing {
    color: #4FACFE;
  }

  .status-danger {
    color: #f56c6c;
  }
}
</style>
