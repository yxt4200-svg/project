<template>
  <div class="addBrand-container">
    <HeadLable :title="title" :goback="true" />
    <div class="container">
      <el-form ref="ruleForm" :model="ruleForm" :rules="rules" :inline="false" label-width="180px" class="demo-ruleForm">
        <el-form-item label="账号:" prop="username">
          <el-input v-model="ruleForm.username" placeholder="请输入账号" maxlength="20" />
        </el-form-item>
        <el-form-item label="员工姓名:" prop="name">
          <el-input v-model="ruleForm.name" placeholder="请输入员工姓名" maxlength="12" />
        </el-form-item>
        <el-form-item label="手机号:" prop="phone">
          <el-input v-model="ruleForm.phone" placeholder="请输入手机号" maxlength="11" />
        </el-form-item>
        <el-form-item label="性别:" prop="sex">
          <el-radio-group v-model="ruleForm.sex">
            <el-radio label="男" />
            <el-radio label="女" />
          </el-radio-group>
        </el-form-item>
        <el-form-item label="身份证号:" prop="idNumber" class="idNumber">
          <el-input v-model="ruleForm.idNumber" placeholder="请输入身份证号" maxlength="20" />
        </el-form-item>
        <div class="subBox address">
          <el-button @click="() => $router.push('/employee')">取消</el-button>
          <el-button type="primary" :class="{ continue: actionType === 'add' }" @click="submitForm('ruleForm', false)">保存</el-button>
          <el-button v-if="actionType == 'add'" type="primary" @click="submitForm('ruleForm', true)" class="new-btn">保存并继续添加</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import { queryEmployeeById, addEmployee, editEmployee } from '@/api/employee'

@Component({
  name: 'addEmployee',
  components: {
    HeadLable
  }
})
export default class extends Vue {
  private title = '添加员工'
  private actionType = ''
  private ruleForm:any = {
    name: '',
    phone: '',
    sex: '男',
    idNumber: '',
    username: ''
  }

  private isCellPhone(val: any) {
    if (!/^1(3|4|5|6|7|8)\d{9}$/.test(val)) {
      return false
    } else {
      return true
    }
  }

  private checkphone(rule: any, value: any, callback: any) {
    if (value == '') {
      callback(new Error('请输入手机号'))
    } else if (!this.isCellPhone(value)) {
      callback(new Error('请输入正确的手机号!'))
    } else {
      callback()
    }
  }

  private validID(rule: any, value: any, callback: any) {
    let reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/
    if (value == '') {
      callback(new Error('请输入身份证号码'))
    } else if (reg.test(value)) {
      callback()
    } else {
      callback(new Error('身份证号码不正确'))
    }
  }

  get rules() {
    return {
      name: [{ required: true, validator: (rule:any, value:any, cb:any) => { if (!value) cb(new Error('请输入员工姓名')); else cb() }, trigger: 'blur' }],
      username: [{ required: true, validator: (rule:any, value:any, cb:any) => { if (!value) cb(new Error('请输入账号')); else { const reg = /^([a-z]|[0-9]){3,20}$/; if (!reg.test(value)) cb(new Error('账号输入不符，请输入3-20个字符')); else cb() } }, trigger: 'blur' }],
      phone: [{ required: true, validator: this.checkphone, trigger: 'blur' }],
      idNumber: [{ required: true, validator: this.validID, trigger: 'blur' }]
    }
  }

  created() {
    this.actionType = this.$route.query.id ? 'edit' : 'add'
    if (this.$route.query.id) {
      this.title = '修改员工信息'
      this.init()
    }
  }

  private async init() {
    const id = this.$route.query.id
    queryEmployeeById(id).then((res: any) => {
      if (res.data.code === 1) {
        this.ruleForm = res.data.data
        this.ruleForm.sex = res.data.data.sex === '0' ? '女' : '男'
      } else {
        this.$message.error(res.data.msg)
      }
    })
  }

  private submitForm(formName: any, st: any) {
    ;(this.$refs[formName] as any).validate((valid: any) => {
      if (valid) {
        if (this.actionType === 'add') {
          const params = { ...this.ruleForm, sex: this.ruleForm.sex === '女' ? '0' : '1' }
          addEmployee(params).then((res: any) => {
            if (res.data.code === 1) {
              this.$message.success('员工添加成功！')
              if (!st) this.$router.push({ path: '/employee' })
              else this.ruleForm = { username: '', name: '', phone: '', sex: '男', idNumber: '' }
            } else {
              this.$message.error(res.data.msg)
            }
          })
        } else {
          const params = { ...this.ruleForm, sex: this.ruleForm.sex === '女' ? '0' : '1' }
          editEmployee(params).then((res: any) => {
            if (res.data.code === 1) {
              this.$message.success('员工信息修改成功！')
              this.$router.push({ path: '/employee' })
            } else {
              this.$message.error(res.data.msg)
            }
          })
        }
      } else {
        return false
      }
    })
  }
}
</script>

<style lang="scss" scoped>
.addBrand {
  &-container {
    margin: 30px;
    margin-top: 0px;
    .HeadLable { background-color: transparent; margin-bottom: 0px; padding-left: 0; }
    .container {
      position: relative;
      z-index: 1;
      background: #fff;
      padding: 30px;
      border-radius: 4px;
      .subBox { padding-top: 30px; text-align: center; border-top: solid 1px #ebeef5; }
    }
    .idNumber { margin-bottom: 39px; }
    .el-form-item { margin-bottom: 29px; }
    .el-input { width: 293px; }
  }
}

/* 覆写 el-radio 选中样式为蓝色渐变，和 +新建菜品 按钮视觉保持一致 */
.el-radio__input.is-checked .el-radio__inner {
  border-color: #4FACFE !important;
  background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%) !important;
  box-shadow: 0 4px 10px rgba(79,172,254,0.12);
}
.el-radio__input.is-checked .el-radio__inner::after {
  background: #ffffff !important;
}
/* 使弹窗/表单内的保存并继续添加按钮与其他页面主按钮一致（如果存在） */
.new-btn {
  padding: 8px 16px;
  background: linear-gradient(135deg,#4FACFE 0%,#00F2FE 100%);
  border: none;
  color: #fff;
  border-radius: 8px;
  box-shadow: 0 6px 16px rgba(79,172,254,0.18);
}
</style>
