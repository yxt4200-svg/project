<!--  -->
<template>
  <div class="tab-change">
    <div v-for="item in changedOrderList"
         :key="item.value"
         class="tab-item"
         :class="{ active: item.value === activeIndex }"
         @click="tabChange(item.value)">
      <el-badge :class="{'special-item': item.num < 10}"
                class="item"
                :value="item.num > 99 ? '99+' : item.num"
                :hidden="!([2, 3, 4].includes(item.value) && item.num)">
        {{ item.label }}
      </el-badge>
    </div>
  </div>
</template>

<script lang="ts">
import { Vue, Component, Prop, Watch } from 'vue-property-decorator'
import { getOrderDetailPage } from '@/api/order'

@Component({
  name: 'TabChange'
})
export default class extends Vue {
  @Prop({ default: '' }) orderStatics: any
  @Prop({ default: '' }) defaultActivity: any
  private activeIndex: number = this.defaultActivity || 0

  @Watch('defaultActivity')
  private onChange(val) {
    this.activeIndex = Number(val)
  }

  get changedOrderList() {
    return [
      {
        label: '全部订单',
        value: 0
      },
      {
        label: '待接单',
        value: 2,
        num: this.orderStatics.toBeConfirmed
      },
      {
        label: '待派送',
        value: 3,
        num: this.orderStatics.confirmed
      },
      {
        label: '派送中',
        value: 4,
        num: this.orderStatics.deliveryInProgress
      },
      {
        label: '已完成',
        value: 5
      },
      {
        label: '已取消',
        value: 6
      }
    ]
  }

  private tabChange(activeIndex) {
    this.activeIndex = activeIndex
    this.$emit('tabChange', activeIndex)
  }
}
</script>

<style lang="scss">
.tab-change {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(25, 41, 73, 0.06);
  margin-bottom: 20px;

  /* 按钮样式参考 statistics/index.vue 的 filter-tabs .tab-item */
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
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 44px;
    box-shadow: none;

    &:hover {
      background: #e3f2fd;
      color: #4FACFE;
      transform: none;
      box-shadow: none;
    }

    .item {
      position: relative;
      display: inline-block;
      padding-right: 6px;
      line-height: 1;

      .el-badge__content {
        background-color: #fd3333 !important;
        color: #fff;
        line-height: 18px;
        height: auto;
        min-width: 18px;
        min-height: 18px;
        padding: 0 6px;
        font-size: 12px;
        border-radius: 12px;
      }

      .el-badge__content.is-fixed {
        top: 6px;
        right: -8px;
      }
    }

    &.special-item .el-badge__content {
      width: auto;
      padding: 0 6px;
    }
  }

  /* 激活态样式使用渐变和白色文字，与 index.vue 保持一致 */
  .tab-item.active {
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    color: #ffffff;
    font-weight: 600;
    box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
    border-color: transparent;
  }

  /* 保持第一个 tab 轻微左移以统一视觉（可选） */
  .tab-item:first-child {
    margin-left: 2px;
  }
}
</style>
