<template>
  <div class="container">
    <h2 class="homeTitle">
      今日数据<i>{{ days[1] }}</i
      ><span><router-link to="/statistics">详细数据</router-link></span>
    </h2>
    <div class="overview-container">
      <div class="data-grid">
        <div class="data-item">
          <div class="item-content">
            <p class="item-label">营业额</p>
            <p class="item-value">¥ {{ overviewData.turnover }}</p>
          </div>
        </div>

        <div class="data-item">
          <div class="item-content">
            <p class="item-label">有效订单</p>
            <p class="item-value">{{ overviewData.validOrderCount }}</p>
          </div>
        </div>

        <div class="data-item">
          <div class="item-content">
            <p class="item-label">订单完成率</p>
            <p class="item-value">
              {{ (overviewData.orderCompletionRate * 100).toFixed(0) }}%
            </p>
          </div>
        </div>

        <div class="data-item">
          <div class="item-content">
            <p class="item-label">平均客单价</p>
            <p class="item-value">¥ {{ overviewData.unitPrice }}</p>
          </div>
        </div>

        <div class="data-item">
          <div class="item-content">
            <p class="item-label">新增用户</p>
            <p class="item-value">{{ overviewData.newUsers }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'
import { getday } from '@/utils/formValidate'

@Component({
  name: 'Overview',
})
export default class extends Vue {
  @Prop() private overviewData!: any
  
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

.overview-container {
  .data-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
  }

  .data-item {
    background: #f8fafb;
    border-radius: 12px;
    padding: 24px;
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

    .item-icon {
      font-size: 36px;
      flex-shrink: 0;
      opacity: 0.9;
    }

    .item-content {
      flex: 1;

      .item-label {
        margin: 0;
        font-size: 14px;
        color: #666;
        margin-bottom: 8px;
      }

      .item-value {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
        color: #333;
      }
    }
  }
}
</style>