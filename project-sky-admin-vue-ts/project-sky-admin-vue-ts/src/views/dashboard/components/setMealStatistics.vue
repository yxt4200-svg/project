<template>
  <div class="setmeal-wrapper">
    <div class="header-row">
      <h3 class="title">套餐总览</h3>
      <router-link to="/setmeal" class="manage-link">套餐管理 ›</router-link>
    </div>
    <div class="setmeal-container">
      <div class="stats-grid">
        <div class="stat-item sold">
          <div class="stat-icon">
            <i class="iconfont icon-open"></i>
          </div>
          <div class="stat-content">
            <p class="stat-label">已启售</p>
            <p class="stat-value">{{ setMealData.sold }}</p>
          </div>
        </div>

        <div class="stat-item stopped">
          <div class="stat-icon">
            <i class="iconfont icon-stop"></i>
          </div>
          <div class="stat-content">
            <p class="stat-label">已停售</p>
            <p class="stat-value">{{ setMealData.discontinued }}</p>
          </div>
        </div>

        <router-link to="/setmeal/add" class="add-item">
          <div class="add-icon">
            <i class="el-icon-plus"></i>
          </div>
          <p class="add-text">新增套餐</p>
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component({
  name: 'SetMeal',
})
export default class extends Vue {
  @Prop() private setMealData!: any
}
</script>

<style lang="scss" scoped>
.setmeal-wrapper {
  .header-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;

    .title {
      margin: 0;
      font-size: 18px;
      font-weight: 600;
      color: #333;
    }

    .manage-link {
      font-size: 14px;
      color: #999;
      text-decoration: none;
      
      &:hover {
        color: #4FACFE;
      }
    }
  }
}

.setmeal-container {
  .stats-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;

    @media (max-width: 768px) {
      grid-template-columns: 1fr;
    }
  }

  .stat-item {
    background: #f8fafb;
    border-radius: 12px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 16px;
    transition: all 0.3s ease;
    border: 2px solid transparent;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    &.sold {
      border-color: #4CAF50;
      
      .stat-icon {
        background: linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%);
      }

      .stat-value {
        color: #4CAF50;
      }
    }

    &.stopped {
      border-color: #9E9E9E;
      
      .stat-icon {
        background: linear-gradient(135deg, #9E9E9E 0%, #BDBDBD 100%);
      }

      .stat-value {
        color: #9E9E9E;
      }
    }

    .stat-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;

      i {
        font-size: 24px;
        color: #ffffff;
      }
    }

    .stat-content {
      flex: 1;

      .stat-label {
        margin: 0;
        font-size: 14px;
        color: #666;
        margin-bottom: 8px;
      }

      .stat-value {
        margin: 0;
        font-size: 28px;
        font-weight: 700;
      }
    }
  }

  .add-item {
    background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    text-decoration: none;
    transition: all 0.3s ease;
    border: 2px solid transparent;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      opacity: 0;
      transition: opacity 0.3s ease;
    }

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 16px rgba(0, 242, 254, 0.4);

      &::before {
        opacity: 1;
      }

      .add-icon {
        transform: rotate(90deg);
      }
    }

    .add-icon {
      width: 48px;
      height: 48px;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.3s ease;
      z-index: 1;

      i {
        font-size: 24px;
        color: #ffffff;
        font-weight: bold;
      }
    }

    .add-text {
      margin: 0;
      font-size: 16px;
      font-weight: 600;
      color: #ffffff;
      z-index: 1;
    }
  }
}
</style>