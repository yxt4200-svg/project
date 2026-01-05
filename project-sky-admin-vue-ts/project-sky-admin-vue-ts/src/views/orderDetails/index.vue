<template>
  <div class="order-management-page">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">📦</div>
        <div class="header-content">
          <h2 class="page-title">订单管理</h2>
          <p class="page-subtitle">管理所有订单状态</p>
        </div>
      </div>
    </div>

    <!-- Tab切换 -->
    <div class="tab-container">
      <TabChange
        :order-statics="orderStatics"
        :default-activity="defaultActivity"
        @tabChange="change"
      />
    </div>

    <!-- 主要内容区域 -->
    <div class="content-card" :class="{ hContainer: tableData.length }">
      <!-- 搜索栏 -->
      <div class="search-bar">
        <div class="search-item">
          <label>订单号</label>
          <el-input
            v-model="input"
            placeholder="请填写订单号"
            clearable
            @clear="init(orderStatus)"
            @keyup.enter.native="initFun(orderStatus)"
          />
        </div>
        <div class="search-item">
          <label>手机号</label>
          <el-input
            v-model="phone"
            placeholder="请填写手机号"
            clearable
            @clear="init(orderStatus)"
            @keyup.enter.native="initFun(orderStatus)"
          />
        </div>
        <div class="search-item date-picker">
          <label>下单时间</label>
          <el-date-picker
            v-model="valueTime"
            clearable
            value-format="yyyy-MM-dd HH:mm:ss"
            range-separator="至"
            :default-time="['00:00:00', '23:59:59']"
            type="daterange"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            @clear="init(orderStatus)"
          />
        </div>
        <el-button class="search-btn" type="primary" @click="init(orderStatus, true)">
          <i class="el-icon-search"></i>
          查询
        </el-button>
      </div>

      <!-- 表格 -->
      <el-table
        v-if="tableData.length"
        :data="tableData"
        stripe
        class="order-table"
      >
        <el-table-column key="number" prop="number" label="订单号" />
        <el-table-column
          v-if="[2, 3, 4].includes(orderStatus)"
          key="orderDishes"
          prop="orderDishes"
          label="订单菜品"
        />
        <el-table-column
          v-if="[0].includes(orderStatus)"
          key="status"
          prop="订单状态"
          label="订单状态"
        >
          <template slot-scope="{ row }">
            <span>{{ getOrderType(row) }}</span>
          </template>
        </el-table-column>
        <el-table-column
          v-if="[0, 5, 6].includes(orderStatus)"
          key="consignee"
          prop="consignee"
          label="用户名"
          show-overflow-tooltip
        />
        <el-table-column
          v-if="[0, 5, 6].includes(orderStatus)"
          key="phone"
          prop="phone"
          label="手机号"
        />
        <el-table-column
          v-if="[0, 2, 3, 4, 5, 6].includes(orderStatus)"
          key="address"
          prop="address"
          label="地址"
          :class-name="orderStatus === 6 ? 'address' : ''"
        />
        <el-table-column
          v-if="[0, 6].includes(orderStatus)"
          key="orderTime"
          prop="orderTime"
          label="下单时间"
          class-name="orderTime"
          min-width="110"
        />
        <el-table-column
          v-if="[6].includes(orderStatus)"
          key="cancelTime"
          prop="cancelTime"
          class-name="cancelTime"
          label="取消时间"
          min-width="110"
        />
        <el-table-column
          v-if="[6].includes(orderStatus)"
          key="cancelReason"
          prop="cancelReason"
          label="取消原因"
          class-name="cancelReason"
          :min-width="[6].includes(orderStatus) ? 80 : 'auto'"
        />
        <el-table-column
          v-if="[5].includes(orderStatus)"
          key="deliveryTime"
          prop="deliveryTime"
          label="送达时间"
        />
        <el-table-column
          v-if="[2, 3, 4].includes(orderStatus)"
          key="estimatedDeliveryTime"
          prop="estimatedDeliveryTime"
          label="预计送达时间"
          min-width="110"
        />
        <el-table-column
          v-if="[0, 2, 5].includes(orderStatus)"
          key="amount"
          prop="amount"
          label="实收金额"
          align="center"
        >
          <template slot-scope="{ row }">
            <span>￥{{ (row.amount.toFixed(2) * 100) / 100 }}</span>
          </template>
        </el-table-column>
        <el-table-column
          v-if="[2, 3, 4, 5].includes(orderStatus)"
          key="remark"
          prop="remark"
          label="备注"
          align="center"
        />
        <el-table-column
          v-if="[2, 3, 4].includes(orderStatus)"
          key="tablewareNumber"
          prop="tablewareNumber"
          label="餐具数量"
          align="center"
          min-width="80"
        />
        <el-table-column
          prop="btn"
          label="操作"
          align="center"
          :class-name="orderStatus === 0 ? 'operate' : 'otherOperate'"
          :min-width="
            [2, 3, 4].includes(orderStatus)
              ? 130
              : [0].includes(orderStatus)
              ? 140
              : 'auto'
          "
        >
          <template slot-scope="{ row }">
            <div class="before">
              <el-button
                v-if="row.status === 2"
                type="text"
                class="blueBug"
                @click="orderAccept(row), (isTableOperateBtn = true)"
              >
                接单
              </el-button>
              <el-button
                v-if="row.status === 3"
                type="text"
                class="blueBug"
                @click="cancelOrDeliveryOrComplete(3, row.id)"
              >
                派送
              </el-button>
              <el-button
                v-if="row.status === 4"
                type="text"
                class="blueBug"
                @click="cancelOrDeliveryOrComplete(4, row.id)"
              >
                完成
              </el-button>
            </div>
            <div class="middle">
              <el-button
                v-if="row.status === 2"
                type="text"
                class="delBut"
                @click="orderReject(row), (isTableOperateBtn = true)"
              >
                拒单
              </el-button>
              <el-button
                v-if="[1, 3, 4, 5].includes(row.status)"
                type="text"
                class="delBut"
                @click="cancelOrder(row)"
              >
                取消
              </el-button>
            </div>
            <div class="after">
              <el-button
                type="text"
                class="blueBug non"
                @click="goDetail(row.id, row.status, row)"
              >
                查看
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <Empty v-else :is-search="isSearch" />
      <el-pagination
        v-if="counts > 10"
        class="pageList"
        :page-sizes="[10, 20, 30, 40]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="counts"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 查看弹框部分 -->
    <el-dialog
      title="订单信息"
      :visible.sync="dialogVisible"
      width="53%"
      :before-close="handleClose"
      class="order-dialog"
    >
      <el-scrollbar style="height: 100%">
        <div class="order-top">
          <div>
            <div style="display: inline-block">
              <label style="font-size: 16px">订单号：</label>
              <div class="order-num">
                {{ diaForm.number }}
              </div>
            </div>
            <div
              style="display: inline-block"
              class="order-status"
              :class="{ status3: [3, 4].includes(dialogOrderStatus) }"
            >
              {{
                orderList.filter((item) => item.value === dialogOrderStatus)[0]
                  .label
              }}
            </div>
          </div>
          <p><label>下单时间：</label>{{ diaForm.orderTime }}</p>
        </div>

        <div class="order-middle">
          <div class="user-info">
            <div class="user-info-box">
              <div class="user-name">
                <label>用户名：</label>
                <span>{{ diaForm.consignee }}</span>
              </div>
              <div class="user-phone">
                <label>手机号：</label>
                <span>{{ diaForm.phone }}</span>
              </div>
              <div
                v-if="[2, 3, 4, 5].includes(dialogOrderStatus)"
                class="user-getTime"
              >
                <label>{{
                  dialogOrderStatus === 5 ? '送达时间：' : '预计送达时间：'
                }}</label>
                <span>{{
                  dialogOrderStatus === 5
                    ? diaForm.deliveryTime
                    : diaForm.estimatedDeliveryTime
                }}</span>
              </div>
              <div class="user-address">
                <label>地址：</label>
                <span>{{ diaForm.address }}</span>
              </div>
            </div>
            <div
              class="user-remark"
              :class="{ orderCancel: dialogOrderStatus === 6 }"
            >
              <div>{{ dialogOrderStatus === 6 ? '取消原因' : '备注' }}</div>
              <span>{{
                dialogOrderStatus === 6
                  ? diaForm.cancelReason || diaForm.rejectionReason
                  : diaForm.remark
              }}</span>
            </div>
          </div>

          <div class="dish-info">
            <div class="dish-label">菜品</div>
            <div class="dish-list">
              <div
                v-for="(item, index) in diaForm.orderDetailList"
                :key="index"
                class="dish-item"
              >
                <div class="dish-item-box">
                  <span class="dish-name">{{ item.name }}</span>
                  <span class="dish-num">x{{ item.number }}</span>
                </div>
                <span class="dish-price"
                  >￥{{ item.amount ? item.amount.toFixed(2) : '' }}</span
                >
              </div>
            </div>
            <div class="dish-all-amount">
              <label>菜品小计</label>
              <span
                >￥{{
                  (diaForm.amount - 6 - diaForm.packAmount).toFixed(2)
                }}</span
              >
            </div>
          </div>
        </div>

        <div class="order-bottom">
          <div class="amount-info">
            <div class="amount-label">费用</div>
            <div class="amount-list">
              <div class="dish-amount">
                <span class="amount-name">菜品小计：</span>
                <span class="amount-price"
                  >￥{{
                    ((diaForm.amount - 6 - diaForm.packAmount).toFixed(2) *
                      100) /
                    100
                  }}</span
                >
              </div>
              <div class="send-amount">
                <span class="amount-name">派送费：</span>
                <span class="amount-price">￥{{ 6 }}</span>
              </div>
              <div class="package-amount">
                <span class="amount-name">打包费：</span>
                <span class="amount-price"
                  >￥{{
                    diaForm.packAmount
                      ? (diaForm.packAmount.toFixed(2) * 100) / 100
                      : ''
                  }}</span
                >
              </div>
              <div class="all-amount">
                <span class="amount-name">合计：</span>
                <span class="amount-price"
                  >￥{{
                    diaForm.amount
                      ? (diaForm.amount.toFixed(2) * 100) / 100
                      : ''
                  }}</span
                >
              </div>
              <div class="pay-type">
                <span class="pay-name">支付渠道：</span>
                <span class="pay-value">{{
                  diaForm.payMethod === 1 ? '微信支付' : '支付宝支付'
                }}</span>
              </div>
              <div class="pay-time">
                <span class="pay-name">支付时间：</span>
                <span class="pay-value">{{ diaForm.checkoutTime }}</span>
              </div>
            </div>
          </div>
        </div>
      </el-scrollbar>
      <span v-if="dialogOrderStatus !== 6" slot="footer" class="dialog-footer">
        <el-checkbox
          v-if="dialogOrderStatus === 2 && orderStatus === 2"
          v-model="isAutoNext"
          >处理完自动跳转下一条</el-checkbox
        >
        <el-button
          v-if="dialogOrderStatus === 2"
          @click="orderReject(row), (isTableOperateBtn = false)"
          >拒 单</el-button
        >
        <el-button
          v-if="dialogOrderStatus === 2"
          type="primary"
          @click="orderAccept(row), (isTableOperateBtn = false)"
          >接 单</el-button
        >

        <el-button
          v-if="[1, 3, 4, 5].includes(dialogOrderStatus)"
          @click="dialogVisible = false"
          >返 回</el-button
        >
        <el-button
          v-if="dialogOrderStatus === 3"
          type="primary"
          @click="cancelOrDeliveryOrComplete(3, row.id)"
          >派 送</el-button
        >
        <el-button
          v-if="dialogOrderStatus === 4"
          type="primary"
          @click="cancelOrDeliveryOrComplete(4, row.id)"
          >完 成</el-button
        >
        <el-button
          v-if="[1].includes(dialogOrderStatus)"
          type="primary"
          @click="cancelOrder(row)"
          >取消订单</el-button
        >
      </span>
    </el-dialog>

    <!-- 拒单，取消弹窗 -->
    <el-dialog
      :title="cancelDialogTitle + '原因'"
      :visible.sync="cancelDialogVisible"
      width="42%"
      :before-close="() => ((cancelDialogVisible = false), (cancelReason = ''))"
      class="cancelDialog"
    >
      <el-form label-width="90px">
        <el-form-item :label="cancelDialogTitle + '原因：'">
          <el-select
            v-model="cancelReason"
            :placeholder="'请选择' + cancelDialogTitle + '原因'"
          >
            <el-option
              v-for="(item, index) in cancelDialogTitle === '取消'
                ? cancelrReasonList
                : cancelOrderReasonList"
              :key="index"
              :label="item.label"
              :value="item.label"
            />
          </el-select>
        </el-form-item>
        <el-form-item v-if="cancelReason === '自定义原因'" label="原因：">
          <el-input
            v-model.trim="remark"
            type="textarea"
            :placeholder="'请填写您' + cancelDialogTitle + '的原因（限20字内）'"
            maxlength="20"
          />
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click=";(cancelDialogVisible = false), (cancelReason = '')"
          >取 消</el-button
        >
        <el-button type="primary" @click="confirmCancel">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import InputAutoComplete from '@/components/InputAutoComplete/index.vue'
import TabChange from './tabChange.vue'
import Empty from '@/components/Empty/index.vue'
import {
  getOrderDetailPage,
  queryOrderDetailById,
  completeOrder,
  deliveryOrder,
  orderCancel,
  orderReject,
  orderAccept,
  getOrderListBy,
} from '@/api/order'

@Component({
  components: {
    HeadLable,
    InputAutoComplete,
    TabChange,
    Empty,
  },
})
export default class extends Vue {
  private defaultActivity: any = 0
  private orderStatics = {}
  private row = {}
  private isAutoNext = true
  private isTableOperateBtn = true
  private currentPageIndex = 0
  private orderId = ''
  private input = ''
  private phone = ''
  private valueTime = []
  private dialogVisible = false
  private cancelDialogVisible = false
  private cancelDialogTitle = ''
  private cancelReason = ''
  private remark = ''
  private counts: number = 0
  private page: number = 1
  private pageSize: number = 10
  private tableData = []
  private diaForm = []
  private isSearch: boolean = false
  private orderStatus = 0
  private dialogOrderStatus = 0
  private cancelOrderReasonList = [
    {
      value: 1,
      label: '订单量较多,暂时无法接单',
    },
    {
      value: 2,
      label: '菜品已销售完，暂时无法接单',
    },
    {
      value: 3,
      label: '餐厅已打烊，暂时无法接单',
    },
    {
      value: 0,
      label: '自定义原因',
    },
  ]

  private cancelrReasonList = [
    {
      value: 1,
      label: '订单量较多，暂时无法接单',
    },
    {
      value: 2,
      label: '菜品已销售完，暂时无法接单',
    },
    {
      value: 3,
      label: '骑手不足无法配送',
    },
    {
      value: 4,
      label: '客户电话取消',
    },
    {
      value: 0,
      label: '自定义原因',
    },
  ]
  private orderList = [
    {
      label: '全部订单',
      value: 0,
    },
    {
      label: '待付款',
      value: 1,
    },
    {
      label: '待接单',
      value: 2,
    },
    {
      label: '待派送',
      value: 3,
    },
    {
      label: '派送中',
      value: 4,
    },
    {
      label: '已完成',
      value: 5,
    },
    {
      label: '已取消',
      value: 6,
    },
  ]

  created() {
    this.init(Number(this.$route.query.status) || 0)
  }

  mounted() {
    if (
      this.$route.query.orderId &&
      this.$route.query.orderId !== 'undefined'
    ) {
      this.goDetail(this.$route.query.orderId, 2)
    }
    if (this.$route.query.status) {
      this.defaultActivity = this.$route.query.status
    }
  }

  initFun(orderStatus) {
    this.page = 1
    this.init(orderStatus)
  }

  change(activeIndex) {
    if (activeIndex === this.orderStatus) return
    this.init(activeIndex)
    this.input = ''
    this.phone = ''
    this.valueTime = []
    this.dialogOrderStatus = 0
    this.$router.push('/order')
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

  init(activeIndex: number = 0, isSearch?) {
    this.isSearch = isSearch
    const params = {
      page: this.page,
      pageSize: this.pageSize,
      number: this.input || undefined,
      phone: this.phone || undefined,
      beginTime:
        this.valueTime && this.valueTime.length > 0
          ? this.valueTime[0]
          : undefined,
      endTime:
        this.valueTime && this.valueTime.length > 0
          ? this.valueTime[1]
          : undefined,
      status: activeIndex || undefined,
    }
    getOrderDetailPage({ ...params })
      .then((res) => {
        if (res.data.code === 1) {
          this.tableData = res.data.data.records
          this.orderStatus = activeIndex
          this.counts = Number(res.data.data.total)
          this.getOrderListBy3Status()
          if (
            this.dialogOrderStatus === 2 &&
            this.orderStatus === 2 &&
            this.isAutoNext &&
            !this.isTableOperateBtn &&
            res.data.data.records.length > 1
          ) {
            const row = res.data.data.records[0]
            this.goDetail(row.id, row.status, row)
          } else {
            return null
          }
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  getOrderType(row: any) {
    if (row.status === 1) {
      return '待付款'
    } else if (row.status === 2) {
      return '待接单'
    } else if (row.status === 3) {
      return '待派送'
    } else if (row.status === 4) {
      return '派送中'
    } else if (row.status === 5) {
      return '已完成'
    } else if (row.status === 6) {
      return '已取消'
    } else {
      return '退款'
    }
  }

  async goDetail(id: any, status: number, row?: any) {
    this.diaForm = []
    this.dialogVisible = true
    this.dialogOrderStatus = status
    this.orderId = id
    const { data } = await queryOrderDetailById({ orderId: id })
    this.diaForm = data.data
    this.row = row || { id: this.$route.query.orderId, status: status }
    if (this.$route.query.orderId) {
      this.$router.push('/order')
    }
  }

  orderReject(row: any) {
    this.cancelDialogVisible = true
    this.orderId = row.id
    this.dialogOrderStatus = row.status
    this.cancelDialogTitle = '拒绝'
    this.dialogVisible = false
    this.cancelReason = ''
  }

  orderAccept(row: any) {
    this.orderId = row.id
    this.dialogOrderStatus = row.status
    orderAccept({ id: this.orderId })
      .then((res) => {
        if (res.data.code === 1) {
          this.$message.success('操作成功')
          this.orderId = ''
          this.dialogVisible = false
          this.init(this.orderStatus)
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  cancelOrder(row: any) {
    this.cancelDialogVisible = true
    this.orderId = row.id
    this.dialogOrderStatus = row.status
    this.cancelDialogTitle = '取消'
    this.dialogVisible = false
    this.cancelReason = ''
  }

  confirmCancel(type) {
    if (!this.cancelReason) {
      return this.$message.error(`请选择${this.cancelDialogTitle}原因`)
    } else if (this.cancelReason === '自定义原因' && !this.remark) {
      return this.$message.error(`请输入${this.cancelDialogTitle}原因`)
    }

    ;(this.cancelDialogTitle === '取消' ? orderCancel : orderReject)({
      id: this.orderId,
      [this.cancelDialogTitle === '取消' ? 'cancelReason' : 'rejectionReason']:
        this.cancelReason === '自定义原因' ? this.remark : this.cancelReason,
    })
      .then((res) => {
        if (res.data.code === 1) {
          this.$message.success('操作成功')
          this.cancelDialogVisible = false
          this.orderId = ''
          this.init(this.orderStatus)
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  cancelOrDeliveryOrComplete(status: number, id: string) {
    const params = {
      status,
      id,
    }
    ;(status === 3 ? deliveryOrder : completeOrder)(params)
      .then((res) => {
        if (res.data.code === 1) {
          this.$message.success('操作成功')
          this.orderId = ''
          this.dialogVisible = false
          this.init(this.orderStatus)
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  handleClose() {
    this.dialogVisible = false
  }

  private handleSizeChange(val: any) {
    this.pageSize = val
    this.init(this.orderStatus)
  }

  private handleCurrentChange(val: any) {
    this.page = val
    this.init(this.orderStatus)
  }
}
</script>

<style lang="scss" scoped>
.order-management-page {
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

  // Tab容器
  .tab-container {
    margin-bottom: 20px;
  }

  // 内容卡片
  .content-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
    min-height: 600px;

    &.hContainer {
      min-height: auto;
    }
  }

  // 搜索栏
  .search-bar {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 24px;
    flex-wrap: wrap;

    .search-item {
      display: flex;
      align-items: center;
      gap: 8px;

      label {
        font-size: 14px;
        color: #666;
        white-space: nowrap;
      }

      .el-input {
        width: 200px;
      }

      &.date-picker {
        .el-date-editor {
          width: 350px;
        }
      }
    }

    .search-btn {
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      border: none;
      color: #ffffff;
      padding: 10px 24px;
      border-radius: 8px;
      font-size: 14px;
      transition: all 0.3s ease;

      &:hover {
        background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(79, 172, 254, 0.3);
      }

      i {
        margin-right: 4px;
      }
    }
  }

  // 表格
  .order-table {
    border: 1px solid #e8ecf0;
    border-radius: 8px;
    overflow: hidden;
  }

  // 分页
  .pageList {
    text-align: center;
    margin-top: 24px;
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

// 以下是订单详情弹窗的样式（保持原有样式）
.info-box {
  margin: -15px -44px 20px;
  p {
    display: flex;
    height: 20px;
    line-height: 20px;
    font-size: 14px;
    font-weight: 400;
    color: #666666;
    text-align: left;
    margin-bottom: 14px;
    &:last-child {
      margin-bottom: 0;
    }
    label {
      width: 100px;
      display: inline-block;
      color: #666;
    }
    .des {
      flex: 1;
      color: #333333;
    }
  }
}

.order-top {
  border-bottom: 1px solid #e7e6e6;
  padding-bottom: 26px;
  padding-left: 22px;
  padding-right: 22px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  .order-status {
    width: 57.25px;
    height: 27px;
    background: #333333;
    border-radius: 13.5px;
    color: white;
    margin-left: 19px;
    text-align: center;
    line-height: 27px;
  }
  .status3 {
    background: #f56c6c;
  }
  p {
    color: #333;
    label {
      color: #666;
    }
  }
  .order-num {
    font-size: 16px;
    color: #2a2929;
    font-weight: bold;
    display: inline-block;
  }
}

.order-middle {
  .user-info {
    min-height: 140px;
    background: #fbfbfa;
    margin-top: 23px;
    padding: 20px 43px;
    color: #333;
    .user-info-box {
      min-height: 55px;
      display: flex;
      flex-wrap: wrap;
      .user-name {
        flex: 67%;
      }
      .user-phone {
        flex: 33%;
      }
      .user-getTime {
        margin-top: 14px;
        flex: 80%;
        label {
          margin-right: 3px;
        }
      }
      label {
        margin-right: 17px;
        color: #666;
      }

      .user-address {
        margin-top: 14px;
        flex: 80%;
        label {
          margin-right: 30px;
        }
      }
    }
    .user-remark {
      min-height: 43px;
      line-height: 43px;
      background: #fffbf0;
      border: 1px solid #fbe396;
      border-radius: 4px;
      margin-top: 10px;
      padding: 6px;
      display: flex;
      align-items: center;
      div {
        display: inline-block;
        min-width: 53px;
        height: 32px;
        background: #fbe396;
        border-radius: 4px;
        text-align: center;
        line-height: 32px;
        color: #333;
        margin-right: 30px;
      }
      span {
        color: #f2a402;
        line-height: 1.15;
      }
    }
    .orderCancel {
      background: #ffffff;
      border: 1px solid #b6b6b6;

      div {
        padding: 0 10px;
        background-color: #e5e4e4;
      }
      span {
        color: #f56c6c;
      }
    }
  }
  .dish-info {
    display: flex;
    flex-wrap: wrap;
    padding: 20px 40px;
    border-bottom: 1px solid #e7e6e6;
    .dish-label {
      color: #666;
    }
    .dish-list {
      flex: 80%;
      display: flex;
      flex-wrap: wrap;
      .dish-item {
        flex: 50%;
        margin-bottom: 14px;
        color: #333;
        .dish-num {
        }
        .dish-item-box {
          display: inline-block;
          width: 120px;
        }
      }
    }
    .dish-label {
      margin-right: 65px;
    }
    .dish-all-amount {
      flex: 1;
      padding-left: 92px;
      margin-top: 10px;
      label {
        color: #333333;
        font-weight: bold;
        margin-right: 5px;
      }
      span {
        color: #f56c6c;
      }
    }
  }
}
.order-bottom {
  .amount-info {
    display: flex;
    flex-wrap: wrap;
    padding: 20px 40px;
    padding-bottom: 0px;
    .amount-label {
      color: #666;
      margin-right: 65px;
    }
    .amount-list {
      flex: 80%;
      display: flex;
      flex-wrap: wrap;
      color: #333;
      .dish-amount,
      .package-amount,
      .pay-type {
        display: inline-block;
        width: 300px;
        margin-bottom: 14px;
        flex: 50%;
      }
      .send-amount,
      .all-amount,
      .pay-time {
        display: inline-block;
        flex: 50%;
        padding-left: 10%;
      }
      .package-amount {
        .amount-name {
          margin-right: 14px;
        }
      }
      .all-amount {
        .amount-name {
          margin-right: 24px;
        }
        .amount-price {
          color: #f56c6c;
        }
      }
      .send-amount {
        .amount-name {
          margin-right: 10px;
        }
      }
    }
  }
}
</style>

<style lang="scss">
.order-management-page {
  .cancelReason {
    padding-left: 40px;
  }
  .cancelTime {
    padding-left: 50px;
  }
  .orderTime {
    padding-left: 50px;
  }
  td.operate .cell {
    .before,
    .middle,
    .after {
      height: 39px;
      width: 48px;
    }
  }
  td.operate .cell,
  td.otherOperate .cell {
    display: flex;
    flex-wrap: nowrap;
    justify-content: center;
  }
  
  // 蓝色主题按钮
  .blueBug {
    color: #4FACFE;
    
    &:hover {
      color: #00F2FE;
    }
  }

  // 主要按钮样式
  .el-button--primary {
    background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
    border: none;
    
    &:hover,
    &:focus {
      background: linear-gradient(135deg, #00F2FE 0%, #4FACFE 100%);
      box-shadow: 0 4px 12px rgba(79, 172, 254, 0.3);
    }
  }

  .order-dialog {
    .el-dialog {
      max-height: 764px !important;
      display: flex;
      flex-direction: column;
      margin: 0 !important;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      max-height: calc(100% - 30px);
      max-width: calc(100% - 30px);
    }
    .el-dialog__body {
      height: 520px !important;
    }
  }
}

.el-dialog__body {
  padding-top: 34px;
  padding-left: 30px;
  padding-right: 30px;
}

.cancelDialog {
  .el-dialog__body {
    padding-left: 64px;
  }
  .el-select,
  .el-textarea {
    width: 293px;
  }
  .el-textarea textarea {
    height: 114px;
  }
}

.el-dialog__footer {
  .el-checkbox {
    float: left;
    margin-left: 40px;
  }
  .el-checkbox__label {
    color: #333333 !important;
  }
}

.empty-box {
  display: flex;
  align-items: center;
  justify-content: center;
  img {
    margin-top: 0 !important;
  }
}
</style>