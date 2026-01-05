<template>
  <div class="category-page">
    <div class="page-header">
      <div class="header-left">
        <div class="header-icon">📁</div>
        <div class="header-content">
          <h2 class="page-title">分类管理</h2>
          <p class="page-subtitle">管理菜品/套餐分类</p>
        </div>
      </div>
    </div>

    <div class="filter-card">
      <div class="search-bar">
        <div class="search-item">
          <label>分类名称：</label>
          <el-input v-model="name" placeholder="请填写分类名称" clearable @clear="init" @keyup.enter.native="init" />
        </div>

        <div class="search-item">
          <label>分类类型：</label>
          <el-select v-model="categoryType" placeholder="请选择" clearable @clear="init">
            <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </div>

        <el-button class="search-btn" @click="init(true)">
          查询
        </el-button>
      </div>

      <div class="ops-area">
        <div class="tableLab">
        </div>
        <el-button class="black-btn" @click="addClass('class')">+ 新增菜品分类</el-button>
        <el-button class="new-btn" @click="addClass('meal')">+ 新增套餐分类</el-button>
      </div>
    </div>

    <div class="content-card">
      <el-table v-if="tableData.length" :data="tableData" stripe class="tableBox">
        <el-table-column prop="name" label="分类名称" />
        <el-table-column prop="type" label="分类类型">
          <template slot-scope="scope">
            <span>{{ scope.row.type == '1' ? '菜品分类' : '套餐分类' }}</span>
          </template>
        </el-table-column>

        <el-table-column prop="sort" label="排序" />
        <el-table-column label="状态">
          <template slot-scope="scope">
            <div class="tableColumn-status" :class="{ 'stop-use': String(scope.row.status) === '0' }">
              {{ String(scope.row.status) === '0' ? '禁用' : '启用' }}
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="updateTime" label="操作时间" />
        <el-table-column label="操作" width="200" align="center">
          <template slot-scope="scope">
            <el-button type="text" size="small" class="blueBug" @click="editHandle(scope.row)">修改</el-button>
            <el-button type="text" size="small" class="delBut" @click="deleteHandle(scope.row.id)">删除</el-button>
            <el-button
              type="text"
              size="small"
              class="non"
              :class="{ blueBug: scope.row.status == '0', delBut: scope.row.status != '0' }"
              @click="statusHandle(scope.row)"
            >
              {{ scope.row.status == '1' ? '禁用' : '启用' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <Empty v-else :is-search="isSearch" />
      <el-pagination v-if="counts > 10" class="pageList" :page-sizes="[10, 20, 30, 40]" :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper" :total="counts" @size-change="handleSizeChange" @current-change="handleCurrentChange" />
    </div>

    <el-dialog :title="classData.title" :visible.sync="classData.dialogVisible" width="30%" :before-close="handleClose">
      <el-form ref="classData" :model="classData" class="demo-form-inline" :rules="rules" label-width="100px">
        <el-form-item label="分类名称：" prop="name">
          <el-input v-model="classData.name" placeholder="请输入分类名称" maxlength="20" />
        </el-form-item>
        <el-form-item label="排序：" prop="sort">
          <el-input v-model="classData.sort" placeholder="请输入排序" />
        </el-form-item>
      </el-form>

      <span slot="footer" class="dialog-footer">
        <el-button size="medium" @click=";(classData.dialogVisible = false), $refs.classData.resetFields()">取消</el-button>
        <el-button type="primary" :class="{ continue: actionType === 'add' }" size="medium" @click="submitForm()">确定</el-button>
        <el-button v-if="action != 'edit'" type="primary" size="medium" class="new-btn" @click="submitForm('go')">保存并继续添加</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import {
  getCategoryPage,
  deleCategory,
  editCategory,
  addCategory,
  enableOrDisableEmployee
} from '@/api/category'
import Empty from '@/components/Empty/index.vue'

@Component({
  name: 'Category',
  components: {
    HeadLable,
    Empty
  }
})
export default class extends Vue {
  private options: any = [
    {
      value: 1,
      label: '菜品分类'
    },
    {
      value: 2,
      label: '套餐分类'
    }
  ]
  private actionType: string = ''
  private id = ''
  private status = ''
  private categoryType: number = null
  private name: string = ''
  private action: string = ''
  private counts: number = 0
  private page: number = 1
  private pageSize: number = 10
  private tableData = []
  private type = ''
  private isSearch: boolean = false
  private classData: any = {
    title: '添加菜品分类',
    dialogVisible: false,
    categoryId: '',
    name: '',
    sort: ''
  }

  get rules() {
    return {
      name: [
        {
          required: true,
          trigger: 'blur',
          validator: (rule: any, value: string, callback: Function) => {
            var reg = new RegExp('^[A-Za-z\u4e00-\u9fa5]+$')
            if (!value) {
              callback(new Error(this.classData.title + '不能为空'))
            } else if (value.length < 2) {
              callback(new Error('分类名称输入不符，请输入2-20个字符'))
            } else if (!reg.test(value)) {
              callback(new Error('分类名称包含特殊字符'))
            } else {
              callback()
            }
          }
        }
      ],
      sort: [
        {
          required: true,
          trigger: 'blur',
          validator: (rule: any, value: string, callback: Function) => {
            if (value || String(value) === '0') {
              const reg = /^\d+$/
              if (!reg.test(value)) {
                callback(new Error('排序只能输入数字类型'))
              } else if (Number(value) > 99) {
                callback(new Error('排序只能输入0-99数字'))
              } else {
                callback()
              }
            } else {
              callback(new Error('排序不能为空'))
            }
          }
        }
      ]
    }
  }

  created() {
    this.init()
  }

  private async init(isSearch?) {
    this.isSearch = isSearch
    await getCategoryPage({
      page: this.page,
      pageSize: this.pageSize,
      name: this.name ? this.name : undefined,
      type: this.categoryType ? this.categoryType : undefined
    })
      .then(res => {
        if (String(res.data.code) === '1') {
          this.tableData = res && res.data && res.data.data && res.data.data.records
          this.counts = Number(res.data.data.total)
        } else {
          this.$message.error(res.data.desc)
        }
      })
      .catch(err => {
        console.log(err, 'err')
        this.$message.error('请求出错了：' + err.message)
      })
  }

  private addClass(st: any) {
    if (st == 'class') {
      this.classData.title = '新增菜品分类'
      this.type = '1'
    } else {
      this.classData.title = '新增套餐分类'
      this.type = '2'
    }
    this.action = 'add'
    this.classData.name = ''
    this.classData.sort = ''
    this.classData.dialogVisible = true
    this.actionType = 'add'
  }

  private editHandle(dat: any) {
    this.classData.title = '修改分类'
    this.action = 'edit'
    this.classData.name = dat.name
    this.classData.sort = dat.sort
    this.classData.id = dat.id
    this.classData.dialogVisible = true
    this.actionType = 'edit'
  }

  private handleClose(st: string) {
    this.classData.dialogVisible = false
    this.$refs.classData.resetFields()
  }

  private statusHandle(row: any) {
    this.id = row.id
    this.status = row.status
    this.$confirm('确认调整该分类的状态?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
      customClass: 'customClass'
    }).then(() => {
      enableOrDisableEmployee({ id: this.id, status: !this.status ? 1 : 0 })
        .then(res => {
          if (String(res.status) === '200') {
            this.$message.success('分类状态更改成功！')
            this.init()
          }
        })
        .catch(err => {
          this.$message.error('请求出错了：' + err.message)
        })
    })
  }

  private deleteHandle(id: any) {
    this.$confirm('此操作将永久删除该分类，是否继续？', '确定删除', {
      confirmButtonText: '删除',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      deleCategory(id)
        .then(res => {
          if (res.data.code === 1) {
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

  $refs!: {
    classData: any
  }

  submitForm(st: any) {
    if (this.action === 'add') {
      this.$refs.classData.validate((value: boolean) => {
        if (value) {
          addCategory({
            name: this.classData.name,
            type: this.type,
            sort: this.classData.sort
          })
            .then(res => {
              if (res.data.code === 1) {
                this.$message.success('分类添加成功！')
                this.$refs.classData.resetFields()
                if (!st) {
                  this.classData.dialogVisible = false
                }
                this.init()
              } else {
                this.$message.error(res.data.desc || res.data.msg)
              }
            })
            .catch(err => {
              this.$message.error('请求出错了：' + err.message)
            })
        }
      })
    } else {
      this.$refs.classData.validate((value: boolean) => {
        if (value) {
          editCategory({
            id: this.classData.id,
            name: this.classData.name,
            sort: this.classData.sort
          })
            .then(res => {
              if (res.data.code === 1) {
                this.$message.success('分类修改成功！')
                this.classData.dialogVisible = false
                this.$refs.classData.resetFields()
                this.init()
              } else {
                this.$message.error(res.data.desc || res.data.msg)
              }
            })
            .catch(err => {
              this.$message.error('请求出错了：' + err.message)
            })
        }
      })
    }
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
.category-page {
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
    }
  }

  .ops-area {
    display:flex;
    align-items:center;
    gap:12px;
    .tableLab { margin-right:8px; }
    .black-btn {
      background: #333333;
      color: #fff;
      padding: 8px 14px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
    }
    .yellow-btn {
      background: #f6b500;
      color: #fff;
      padding: 8px 14px;
      border-radius: 6px;
      border: none;
      cursor: pointer;
      box-shadow: none;
    }
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
    min-height: 520px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  }

  .tableBox { width: 100%; border: 1px solid #ebeef5; border-bottom: 0; }
  .tableColumn-status { display:inline-block; padding:4px 10px; border-radius:12px; color:#4a4a4a; }

  .pageList { text-align: center; margin-top: 30px; }

  /* 弹窗底部新按钮样式覆盖，改为与页面新建按钮一致 */
  .el-dialog__footer .new-btn {
    padding: 8px 16px;
    background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%);
    border: none;
    color: #fff;
    border-radius: 8px;
    box-shadow: 0 6px 16px rgba(79,172,254,0.18);
    cursor: pointer;
    transition: all .18s;
    margin-left: 12px;
  }
  .el-dialog__footer .new-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 22px rgba(79,172,254,0.22);
  }
}
</style>
