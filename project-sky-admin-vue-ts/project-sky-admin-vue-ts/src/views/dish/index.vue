<template>
  <div class="dish-page">
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">🍽️</div>
        <div class="header-content">
          <h2 class="page-title">菜品管理</h2>
          <p class="page-subtitle">管理并配置菜品信息</p>
        </div>
      </div>
    </div>

    <div class="filter-card">
      <div class="search-bar">
        <div class="search-item">
          <label>菜品名称</label>
          <el-input v-model="input" placeholder="请填写菜品名称" clearable @clear="init" @keyup.enter.native="initFun" />
        </div>

        <div class="search-item">
          <label>菜品分类</label>
          <el-select v-model="categoryId" placeholder="请选择" clearable @clear="init">
            <el-option v-for="item in dishCategoryList" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </div>

        <div class="search-item">
          <label>售卖状态</label>
          <el-select v-model="dishStatus" placeholder="请选择" clearable @clear="init">
            <el-option v-for="item in saleStatus" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </div>

        <el-button class="search-btn" @click="init(true)">
          <i class="el-icon-search"></i> 查询
        </el-button>
      </div>

      <div class="ops-area">
        <div class="tableLab">
          <span class="delBut non" @click="deleteHandle('批量', null)">批量删除</span>
        </div>
        <el-button class="new-btn" type="primary" @click="addDishtype('add')">+ 新建菜品</el-button>
      </div>
    </div>

    <div class="content-card">
      <el-table v-if="tableData.length" :data="tableData" stripe class="tableBox" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="25" />
        <el-table-column prop="name" label="菜品名称" />
        <el-table-column prop="image" label="图片">
          <template slot-scope="{ row }">
            <el-image style="width: 80px; height: 40px; border: none; cursor: pointer" :src="row.image">
              <div slot="error" class="image-slot">
                <img src="./../../assets/noImg.png" style="width: auto; height: 40px; border: none" />
              </div>
            </el-image>
          </template>
        </el-table-column>
        <el-table-column prop="categoryName" label="菜品分类" />
        <el-table-column label="售价">
          <template slot-scope="scope">
            <span style="margin-right: 10px">￥{{ (scope.row.price ).toFixed(2)*100/100 }}</span>
          </template>
        </el-table-column>
        <!-- 固定列宽，避免状态文字被遮挡 -->
        <el-table-column label="售卖状态" width="120">
          <template slot-scope="scope">
            <div class="tableColumn-status" :class="{ 'stop-use': String(scope.row.status) === '0' }">
              {{ String(scope.row.status) === '0' ? '停售' : '启售' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="updateTime" label="最后操作时间" />
        <el-table-column label="操作" width="250" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" class="blueBug" @click="addDishtype(scope.row.id)">修改</el-button>
            <el-button type="text" size="small" class="delBut" @click="deleteHandle('单删', scope.row.id)">删除</el-button>
            <el-button
              type="text"
              size="small"
              class="non"
              :class="{ blueBug: scope.row.status == '0', delBut: scope.row.status != '0' }"
              @click="statusHandle(scope.row)"
            >
              {{ scope.row.status == '0' ? '启售' : '停售' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <Empty v-else :is-search="isSearch" />
      <el-pagination v-if="counts > 10" class="pageList" :page-sizes="[10,20,30,40]" :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper" :total="counts" @size-change="handleSizeChange" @current-change="handleCurrentChange" />
    </div>
  </div>
</template>
<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import {
  getDishPage,
  editDish,
  deleteDish,
  dishStatusByStatus,
  dishCategoryList
} from '@/api/dish'
import InputAutoComplete from '@/components/InputAutoComplete/index.vue'
import Empty from '@/components/Empty/index.vue'
import { baseUrl } from '@/config.json'

@Component({
  name: 'DishType',
  components: {
    HeadLable,
    InputAutoComplete,
    Empty
  }
})
export default class extends Vue {
  private input: any = ''
  private counts: number = 0
  private page: number = 1
  private pageSize: number = 10
  private checkList: string[] = []
  private tableData: [] = []
  private dishState = ''
  private dishCategoryList = []
  private categoryId = ''
  private dishStatus = ''
  private isSearch: boolean = false
  private saleStatus: any = [
    {
      value: 0,
      label: '停售'
    },
    {
      value: 1,
      label: '启售'
    }
  ]

  created() {
    this.init()
    this.getDishCategoryList()
  }

  initProp(val) {
    this.input = val
    this.initFun()
  }

  initFun() {
    this.page = 1
    this.init()
  }

  private async init(isSearch?) {
    this.isSearch = isSearch
    await getDishPage({
      page: this.page,
      pageSize: this.pageSize,
      name: this.input || undefined,
      categoryId: this.categoryId || undefined,
      status: this.dishStatus
    })
      .then(res => {
        if (res.data.code === 1) {
          this.tableData = res.data && res.data.data && res.data.data.records
          this.counts = Number(res.data.data.total)
        }
      })
      .catch(err => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  // 添加
  private addDishtype(st: string) {
    if (st === 'add') {
      this.$router.push({ path: '/dish/add' })
    } else {
      this.$router.push({ path: '/dish/add', query: { id: st } })
    }
  }

  // 删除
  private deleteHandle(type: string, id: any) {
    if (type === '批量' && id === null) {
      if (this.checkList.length === 0) {
        return this.$message.error('请选择删除对象')
      }
    }
    this.$confirm('确认删除该菜品, 是否继续?', '确定删除', {
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      deleteDish(type === '批量' ? this.checkList.join(',') : id)
        .then(res => {
          if (res && res.data && res.data.code === 1) {
            this.$message.success('删除成功！')
            this.init()
          } else {
            this.$message.error(res.data.msg)
          }
        })
        .catch(err => {
          this.$message.error('请求出错了：' + err.message)
        })
    })
  }
  //获取菜品分类下拉数据
  private getDishCategoryList() {
    dishCategoryList({
      type: 1
    })
      .then(res => {
        if (res && res.data && res.data.code === 1) {
          this.dishCategoryList = (
            res.data &&
            res.data.data &&
            res.data.data
          ).map(item => {
            return { value: item.id, label: item.name }
          })
        }
      })
      .catch(() => {})
  }

  //状态更改
  private statusHandle(row: any) {
    let params: any = {}
    if (typeof row === 'string') {
      if (this.checkList.length === 0) {
        this.$message.error('批量操作，请先勾选操作菜品！')
        return false
      }
      params.id = this.checkList.join(',')
      params.status = row
    } else {
      params.id = row.id
      params.status = row.status ? '0' : '1'
    }
    this.dishState = params
    this.$confirm('确认更改该菜品状态?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      // 起售停售---批量起售停售接口
      dishStatusByStatus(this.dishState)
        .then(res => {
          if (res && res.data && res.data.code === 1) {
            this.$message.success('菜品状态已经更改成功！')
            this.init()
          } else {
            this.$message.error(res.data.msg)
          }
        })
        .catch(err => {
          this.$message.error('请求出错了：' + err.message)
        })
    })
  }

  // 全部操作
  private handleSelectionChange(val: any) {
    let checkArr: any[] = []
    val.forEach((n: any) => {
      checkArr.push(n.id)
    })
    this.checkList = checkArr
  }

  private handleSizeChange(val: any) {
    this.pageSize = val
    this.init()
  }

  private handleCurrentChange(val: any) {
    this.page = val
    this.init()
  }
}
</script>

<style lang="scss">
.dish-page {
  padding: 20px;
  background: #f5f8fa;
  min-height: 100vh;

  .page-header {
    margin-bottom: 20px;
    padding: 24px 28px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(102,126,234,0.18);
    display: flex;
    align-items: center;
    .header-left { display:flex; align-items:center; gap:16px; }
    .header-icon { font-size: 28px; }
    .header-content { color:#fff;
      .page-title{ margin:0; font-size:18px; font-weight:700 }
      .page-subtitle{ margin:0; font-size:12px; opacity:0.9 }
    }
  }

  .filter-card {
    background: #fff;
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
    align-items: center;
    gap: 12px;
    /* 关键：每个搜索项固定宽度，避免遮挡 */
    .search-item {
      display: flex;
      gap: 8px;
      align-items: center;
      label { color:#666; width: 100px; font-size:14px; }
      .el-input, .el-select { width: 220px; }
    }
    .search-btn {
      padding: 8px 18px;
      color: #fff;
      background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%);
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: all .18s;
      &:hover { transform: translateY(-2px); box-shadow:0 6px 14px rgba(79,172,254,0.18) }
      i { margin-right:6px }
    }
  }

  .ops-area {
    display:flex;
    align-items:center;
    gap:12px;
    .tableLab { margin-right:8px;
      .delBut { color:#ff6b6b; cursor:pointer }
    }
    .new-btn {
      padding: 8px 16px;
      background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%) !important;
      border: none !important;
      color: #fff !important;
      border-radius: 8px;
      box-shadow: 0 6px 16px rgba(79,172,254,0.18);
      cursor: pointer;
      transition: all .18s;
      &:hover { transform: translateY(-2px); box-shadow:0 10px 22px rgba(79,172,254,0.22) }
    }
  }

  .content-card {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    min-height: 520px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  }

  .tableBox { width:100%; border:1px solid #ebeef5; border-bottom:0; }

  /* 状态块内边距，避免文字靠边被遮挡 */
  .tableColumn-status { display:inline-block; padding:4px 10px; border-radius:12px; color:#4a4a4a; }

  .pageList { text-align:center; margin-top:30px; }
}
</style>

<style lang="scss" scoped>
/* 若需局部覆盖可放这里，保留原 scoped 规则 */
</style>
