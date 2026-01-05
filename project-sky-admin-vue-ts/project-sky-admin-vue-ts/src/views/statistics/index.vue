<template>
  <div class="dashboard-container statistics-page">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">📊</div>
        <div class="header-content">
          <h2 class="page-title">数据统计</h2>
          <p class="page-subtitle">{{ dateRange }}</p>
        </div>
      </div>
    </div>

    <!-- 时间筛选Tab -->
    <div class="time-filter-card">
      <div class="filter-tabs">
        <div 
          :class="['tab-item', { active: flag === 1 }]" 
          @click="getTitleNum(1)"
        >
          昨日
        </div>
        <div 
          :class="['tab-item', { active: flag === 2 }]" 
          @click="getTitleNum(2)"
        >
          近7日
        </div>
        <div 
          :class="['tab-item', { active: flag === 3 }]" 
          @click="getTitleNum(3)"
        >
          近30日
        </div>
        <div 
          :class="['tab-item', { active: flag === 4 }]" 
          @click="getTitleNum(4)"
        >
          本周
        </div>
        <div 
          :class="['tab-item', { active: flag === 5 }]" 
          @click="getTitleNum(5)"
        >
          本月
        </div>
      </div>
      <div class="date-info">
        已选时间：{{ tateData[0] }} 至 {{ tateData[1] }}
      </div>
      <button class="export-btn" @click="handleExport">
        <i class="el-icon-download"></i>
        导出数据
      </button>
    </div>

    <!-- 数据图表区域 -->
    <div class="charts-grid">
      <!-- 营业额统计 -->
      <div class="chart-card">
        <TurnoverStatistics :turnoverdata="turnoverData" />
      </div>

      <!-- 用户统计 -->
      <div class="chart-card">
        <UserStatistics :userdata="userData" />
      </div>
    </div>

    <!-- 订单和排名区域 -->
    <div class="charts-grid bottom-charts">
      <!-- 订单统计 -->
      <div class="chart-card">
        <OrderStatistics :orderdata="orderData" :overviewData="overviewData" />
      </div>

      <!-- 销量排名TOP10 -->
      <div class="chart-card">
        <Top :top10data="top10Data" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import {
  get1stAndToday,
  past7Day,
  past30Day,
  pastWeek,
  pastMonth,
} from '@/utils/formValidate'
import {
  getDataOverView,
  getTurnoverStatistics,
  getUserStatistics,
  getOrderStatistics,
  getTop,
  exportInfor,
} from '@/api/index'
// 组件
import TurnoverStatistics from './components/turnoverStatistics.vue'
import UserStatistics from './components/userStatistics.vue'
import OrderStatistics from './components/orderStatistics.vue'
import Top from './components/top10.vue'

@Component({
  name: 'Statistics',
  components: {
    TurnoverStatistics,
    UserStatistics,
    OrderStatistics,
    Top,
  },
})
export default class extends Vue {
  private overviewData = {} as any
  private flag = 2
  private tateData = []
  private turnoverData = {} as any
  private userData = {}
  private orderData = {
    data: {},
  } as any
  private top10Data = {}

  get dateRange() {
    const tabNames = {
      1: '昨日数据',
      2: '近7日数据',
      3: '近30日数据',
      4: '本周数据',
      5: '本月数据'
    }
    return tabNames[this.flag] || '数据统计'
  }

  created() {
    this.getTitleNum(2)
  }

  init(begin: any, end: any) {
    this.$nextTick(() => {
      this.getTurnoverStatisticsData(begin, end)
      this.getUserStatisticsData(begin, end)
      this.getOrderStatisticsData(begin, end)
      this.getTopData(begin, end)
    })
  }

  async getTurnoverStatisticsData(begin: any, end: any) {
    const data = await getTurnoverStatistics({ begin: begin, end: end })
    const turnoverData = data.data.data
    this.turnoverData = {
      dateList: turnoverData.dateList.split(','),
      turnoverList: turnoverData.turnoverList.split(',')
    }
  }

  async getUserStatisticsData(begin: any, end: any) {
    const data = await getUserStatistics({ begin: begin, end: end })
    const userData = data.data.data
    this.userData = {
      dateList: userData.dateList.split(','),
      totalUserList: userData.totalUserList.split(','),
      newUserList: userData.newUserList.split(','),
    }
  }

  async getOrderStatisticsData(begin: any, end: any) {
    const data = await getOrderStatistics({ begin: begin, end: end })
    const orderData = data.data.data
    this.orderData = {
      data: {
        dateList: orderData.dateList.split(','),
        orderCountList: orderData.orderCountList.split(','),
        validOrderCountList: orderData.validOrderCountList.split(','),
      },
      totalOrderCount: orderData.totalOrderCount,
      validOrderCount: orderData.validOrderCount,
      orderCompletionRate: orderData.orderCompletionRate
    }
  }

  async getTopData(begin: any, end: any) {
    const data = await getTop({ begin: begin, end: end })
    const top10Data = data.data.data
    this.top10Data = {
      nameList: top10Data.nameList.split(',').reverse(),
      numberList: top10Data.numberList.split(',').reverse(),
    }
  }

  getTitleNum(data) {
    this.flag = data
    switch (data) {
      case 1:
        this.tateData = get1stAndToday()
        break
      case 2:
        this.tateData = past7Day()
        break
      case 3:
        this.tateData = past30Day()
        break
      case 4:
        this.tateData = pastWeek()
        break
      case 5:
        this.tateData = pastMonth()
        break
    }
    this.init(this.tateData[0], this.tateData[1])
  }

  // 数据导出
  handleExport() {
    this.$confirm('是否确认导出最近30天运营数据?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    })
      .then(async function () {
        const { data } = await exportInfor()
        let url = window.URL.createObjectURL(data)
        var a = document.createElement('a')
        document.body.appendChild(a)
        a.href = url
        a.download = '运营数据统计报表.xlsx'
        a.click()
        window.URL.revokeObjectURL(url)
      })
      .then((response) => {})
  }
}
</script>

<style lang="scss" scoped>
.statistics-page {
  padding: 20px;
  background: #f5f8fa;
  min-height: 100vh;

  // 页面头部
  .page-header {
    margin-bottom: 20px;
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
  }

  // 时间筛选卡片
  .time-filter-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    display: flex;
    align-items: center;
    gap: 20px;

    .filter-tabs {
      display: flex;
      gap: 8px;
      flex: 1;

      .tab-item {
        padding: 10px 24px;
        border-radius: 8px;
        background: #f5f7fa;
        color: #666;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s ease;
        border: 2px solid transparent;

        &:hover {
          background: #e3f2fd;
          color: #4FACFE;
        }

        &.active {
          background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
          color: #ffffff;
          font-weight: 600;
          box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
        }
      }
    }

    .date-info {
      font-size: 14px;
      color: #999;
      padding: 0 16px;
      border-left: 1px solid #e8ecf0;
    }

    .export-btn {
      padding: 10px 20px;
      background: #ffffff;
      border: 1px solid #4FACFE;
      border-radius: 8px;
      color: #4FACFE;
      font-size: 14px;
      cursor: pointer;
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      gap: 6px;

      &:hover {
        background: #4FACFE;
        color: #ffffff;
        box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
      }

      i {
        font-size: 16px;
      }
    }
  }

  // 图表网格
  .charts-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24px;
    margin-bottom: 24px;

    @media (max-width: 1200px) {
      grid-template-columns: 1fr;
    }

    &.bottom-charts {
      margin-bottom: 0;
    }
  }

  // 图表卡片
  .chart-card {
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
// 全局样式覆盖
.statistics-page {
  // 确保图表组件也使用蓝色主题
  .el-button--primary {
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    border: none;
    
    &:hover,
    &:focus {
      background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
    }
  }
}
</style>
