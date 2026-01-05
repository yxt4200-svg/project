<template>
  <div class="employee-page">
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">👥</div>
        <div class="header-content">
          <h2 class="page-title">员工管理</h2>
          <p class="page-subtitle">管理系统员工账号信息</p>
        </div>
      </div>
    </div>

    <div class="filter-card">
      <div class="search-bar">
        <div class="search-item">
          <label>员工姓名：</label>
          <el-input
            v-model="input"
            placeholder="请输入员工姓名"
            clearable
            @clear="init"
            @keyup.enter.native="initFun"
          />
        </div>

        <el-button class="search-btn" @click="initFun">
          查询
        </el-button>
      </div>

      <div class="ops-area">
        <div class="tableLab"></div>
        <el-button class="new-btn" type="primary" @click="addEmployeeHandle('add')">+ 添加员工</el-button>
      </div>
    </div>

    <div class="content-card">
      <el-table :data="tableData" stripe v-if="tableData.length" class="tableBox">
        <el-table-column prop="name" label="员工姓名" />
        <el-table-column prop="username" label="账号" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column label="账号状态">
          <template slot-scope="scope">
            <div class="tableColumn-status" :class="{ 'stop-use': String(scope.row.status) === '0' }">
              {{ String(scope.row.status) === '0' ? '禁用' : '启用' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="updateTime" label="最后操作时间" />
        <el-table-column label="操作" width="160" align="center">
          <template slot-scope="scope">
            <el-button
              type="text"
              size="small"
              class="blueBug"
              :class="{ 'disabled-text': scope.row.username === 'admin' }"
              :disabled="scope.row.username === 'admin'"
              @click="addEmployeeHandle(scope.row.id, scope.row.username)"
            >修改</el-button>
            <el-button
              :disabled="scope.row.username === 'admin'"
              type="text"
              size="small"
              class="non"
              :class="{ 'disabled-text': scope.row.username === 'admin', blueBug: scope.row.status == '0', delBut: scope.row.status != '0' }"
              @click="statusHandle(scope.row)"
            >{{ scope.row.status == '1' ? '禁用' : '启用' }}</el-button>
          </template>
        </el-table-column>
      </el-table>

      <Empty v-else :is-search="isSearch" />
      <el-pagination
        class="pageList"
        :page-sizes="[10, 20, 30, 40]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="counts"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import { getEmployeeList, enableOrDisableEmployee } from '@/api/employee'
import InputAutoComplete from '@/components/InputAutoComplete/index.vue'
import Empty from '@/components/Empty/index.vue'

@Component({
  name: 'Employee',
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
  private tableData: any[] = []
  private id = ''
  private status = ''
  private isSearch: boolean = false

  created() {
    this.init()
  }

  initProp(val: any) {
    this.input = val
    this.initFun()
  }

  initFun() {
    this.page = 1
    this.init()
  }

  private async init(isSearch?: boolean) {
    this.isSearch = isSearch
    const params = {
      page: this.page,
      pageSize: this.pageSize,
      name: this.input ? this.input : undefined
    }
    await getEmployeeList(params)
      .then((res: any) => {
        if (String(res.data.code) === '1') {
          this.tableData = res.data && res.data.data && res.data.data.records
          this.counts = res.data.data.total
        }
      })
      .catch((err: any) => {
        this.$message.error('请求出错了：' + err.message)
      })
  }

  // 添加/编辑
  private addEmployeeHandle(st: string, username?: string) {
    if (st === 'add') {
      this.$router.push({ path: '/employee/add' })
    } else {
      if (username === 'admin') return
      this.$router.push({ path: '/employee/add', query: { id: st } })
    }
  }

  //状态修改
  private statusHandle(row: any) {
    if (row.username === 'admin') return
    this.id = row.id
    this.status = row.status
    this.$confirm('确认调整该账号的状态?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      enableOrDisableEmployee({ id: this.id, status: !this.status ? 1 : 0 })
        .then((res: any) => {
          if (String(res.status) === '200') {
            this.$message.success('账号状态更改成功！')
            this.init()
          }
        })
        .catch((err: any) => {
          this.$message.error('请求出错了：' + err.message)
        })
    })
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

<style lang="scss" scoped>
.employee-page {
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
    .header-icon { font-size: 28px; color: #fff; }
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
    .search-item {
      display: flex;
      gap: 8px;
      align-items: center;
      label { color:#666; width: 100px; font-size:14px; }
      .el-input { width: 240px; }
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
    }
  }

  .ops-area {
    display:flex;
    align-items:center;
    gap:12px;
    .new-btn {
      padding: 8px 16px;
      background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%);
      border: none;
      color: #fff;
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
    min-height: 360px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  }

  .tableBox { width: 100%; border: 1px solid #ebeef5; border-bottom: 0; }
  .tableColumn-status { display:inline-block; padding:4px 10px; border-radius:12px; color:#4a4a4a; }

  .pageList { text-align: center; margin-top: 30px; }

  .disabled-text { color: #bac0cd !important; }
}
</style>
