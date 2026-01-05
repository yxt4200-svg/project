<template>
  <div class="setmeal-page">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">🍱</div>
        <div class="header-content">
          <h2 class="page-title">套餐管理</h2>
          <p class="page-subtitle">管理并配置套餐信息</p>
        </div>
      </div>
    </div>

    <!-- 搜索与操作行 -->
    <div class="filter-card">
      <div class="search-bar">
        <div class="search-item">
          <label>套餐名称</label>
          <el-input v-model="name" placeholder="请填写套餐名称" clearable />
        </div>
        <div class="search-item">
          <label>套餐分类</label>
          <el-select v-model="category" placeholder="请选择" clearable>
            <el-option label="全部" value="" />
          </el-select>
        </div>
        <div class="search-item">
          <label>售卖状态</label>
          <el-select v-model="saleStatus" placeholder="请选择" clearable>
            <el-option label="全部" value="" />
            <el-option label="上架" value="1" />
            <el-option label="下架" value="0" />
          </el-select>
        </div>
        <el-button class="search-btn" @click="onSearch">
          <i class="el-icon-search"></i>
          查询
        </el-button>
      </div>

      <div class="ops-area">
        <button class="export-link" @click="onBatchDelete">批量删除</button>
        <el-button class="new-btn" type="primary" @click="onCreate">+ 新建套餐</el-button>
      </div>
    </div>

    <!-- 内容区域（示例空状态） -->
    <div class="content-card">
      <Empty />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import Empty from '@/components/Empty/index.vue'

@Component({
  components: {
    Empty,
  },
})
export default class SetmealIndex extends Vue {
  private name = ''
  private category = ''
  private saleStatus = ''

  onSearch() {
    this.$message.info('执行搜索：' + this.name)
  }

  onBatchDelete() {
    this.$message.warning('批量删除（示例）')
  }

  onCreate() {
    // 直接跳转到新建套餐页面
    this.$router.push({ path: '/setmeal/add' })
  }
}
</script>

<style lang="scss" scoped>
.setmeal-page {
  padding: 20px;
  background: #f5f8fa;
  min-height: 100vh;

  .page-header {
    margin-bottom: 20px;
    padding: 24px 28px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(102, 126, 234, 0.18);
    display: flex;
    align-items: center;

    .header-left {
      display: flex;
      align-items: center;
      gap: 16px;
      z-index: 1;
    }

    .header-icon { font-size: 40px; }

    .header-content {
      .page-title { margin: 0; font-size: 22px; color: #fff; font-weight: 700; }
      .page-subtitle { margin: 0; color: rgba(255,255,255,0.9); font-size: 13px; }
    }
  }

  .filter-card {
    background: #ffffff;
    border-radius: 12px;
    padding: 18px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
  }

  .search-bar {
    display: flex;
    gap: 12px;
    align-items: center;

    .search-item {
      display: flex;
      gap: 8px;
      align-items: center;
      label { color: #666; width: 78px; font-size: 14px; }
      .el-input, .el-select { width: 220px; }
    }

    .search-btn {
      padding: 8px 18px;
      color: #fff;
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      border: none;
      border-radius: 8px;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 6px;
      transition: all 0.18s;
      &:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(79,172,254,0.18); }
      i { font-size: 14px; }
    }
  }

  .ops-area {
    display: flex;
    gap: 12px;
    align-items: center;

    .export-link {
      background: transparent;
      color: #ff6b6b;
      border: none;
      cursor: pointer;
      font-size: 14px;
    }

    /* 新建按钮改为与订单页主按钮一致的蓝色渐变样式 */
    .new-btn {
      padding: 8px 16px;
      background: linear-gradient(135deg, #4FACFE 0%, #00F2FE 100%);
      border: none;
      color: #ffffff;
      border-radius: 8px;
      cursor: pointer;
      box-shadow: 0 6px 16px rgba(79,172,254,0.18);
      transition: all 0.18s;
      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 22px rgba(79,172,254,0.22);
      }
    }
  }

  .content-card {
    background: #fff;
    border-radius: 12px;
    padding: 40px;
    min-height: 400px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  }
}
</style>
