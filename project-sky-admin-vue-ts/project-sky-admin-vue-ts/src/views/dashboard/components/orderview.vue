<template>
  <div class="container">
    <h2 class="homeTitle">
      订单管理<i>{{ days[1] }}</i
      ><span><router-link to="/order">订单明细</router-link></span>
    </h2>
    <div class="orderview-container">
      <div class="order-grid">
        <router-link to="/order?status=2" class="order-item">
          <i class="iconfont icon-waiting"></i>
          <div class="order-info">
            <span class="order-label">待接单</span>
            <span class="order-count">{{ orderviewData.waitingOrders }}</span>
          </div>
        </router-link>

        <router-link to="/order?status=3" class="order-item">
          <i class="iconfont icon-staySway"></i>
          <div class="order-info">
            <span class="order-label">待派送</span>
            <span class="order-count">{{ orderviewData.deliveredOrders }}</span>
          </div>
        </router-link>

        <router-link to="/order?status=5" class="order-item">
          <i class="iconfont icon-complete"></i>
          <div class="order-info">
            <span class="order-label">已完成</span>
            <span class="order-count">{{ orderviewData.completedOrders }}</span>
          </div>
        </router-link>

        <router-link to="/order?status=6" class="order-item">
          <i class="iconfont icon-cancel"></i>
          <div class="order-info">
            <span class="order-label">已取消</span>
            <span class="order-count">{{ orderviewData.cancelledOrders }}</span>
          </div>
        </router-link>

        <router-link to="/order" class="order-item">
          <i class="iconfont icon-all"></i>
          <div class="order-info">
            <span class="order-label">全部订单</span>
            <span class="order-count">{{ orderviewData.allOrders }}</span>
          </div>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'
import { getday } from '@/utils/formValidate'

@Component({
  name: 'Orderview',
})
export default class extends Vue {
  @Prop() private orderviewData!: any
  
  get days() {
    return getday()
  }
}
</script>

<style lang="scss" scoped>
.container {
  background: #ffffff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  margin-bottom: 24px;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  }

  .homeTitle {
    font-size: 18px;
    font-weight: 600;
    color: #333;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    justify-content: space-between;

    i {
      font-size: 14px;
      font-weight: normal;
      color: #999;
      margin-left: 8px;
      font-style: normal;
    }

    span {
      a {
        font-size: 14px;
        color: #999;
        text-decoration: none;
        font-weight: normal;
        
        &:hover {
          color: #4FACFE;
        }
      }
    }
  }
}

.orderview-container {
  .order-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 16px;
  }

  .order-item {
    background: #f8fafb;
    border-radius: 12px;
    padding: 24px;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 16px;
    transition: all 0.3s ease;
    border: 1px solid #e8ecf0;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(79, 172, 254, 0.15);
      border-color: #4FACFE;
    }

    i {
      font-size: 32px;
      color: #4FACFE;
      flex-shrink: 0;
    }

    .order-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 8px;

      .order-label {
        font-size: 14px;
        color: #666;
      }

      .order-count {
        font-size: 28px;
        font-weight: 700;
        color: #333;
      }
    }
  }
}
</style>