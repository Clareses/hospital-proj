# 1. 注册患者
curl -X POST http://127.0.0.1:3435/hospital/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"13912345678","name":"测试患者","password":"123456"}'

# 2. 登录 (获取 token)
curl -X POST http://127.0.0.1:3435/hospital/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"00000000","password":"admin"}'

# 3. 获取医生列表
curl -X GET http://127.0.0.1:3435/hospital/doctor_list

# 4. 添加医生
curl -X POST http://127.0.0.1:3435/hospital/add_doctor \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","name":"测试医生","phone":"13812345678","department":"内科","password":"123456"}'

# 5. 删除医生
curl -X POST http://127.0.0.1:3435/hospital/delete_doctor \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","id":1}'

# 6. 获取药品列表
curl -X GET http://127.0.0.1:3435/hospital/drug_list

# 7. 添加药品
curl -X POST http://127.0.0.1:3435/hospital/add_drug \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","name":"测试药品","amount":50}'

# 8. 删除药品
curl -X POST http://127.0.0.1:3435/hospital/delete_drug \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","id":1}'

# 9. 获取就诊记录列表
curl -X GET http://127.0.0.1:3435/hospital/records_list \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>"}'

# 10. 获取单条就诊记录
curl -X GET http://127.0.0.1:3435/hospital/record \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","record_id":1}'

# 11. 更新诊断记录
curl -X POST http://127.0.0.1:3435/hospital/record \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","record_id":1,"diagnosis":"流感","drug":[{"name":"阿司匹林","amount":2},{"name":"感冒灵","amount":1}]}'

# 12. 获取就诊历史
curl -X GET http://127.0.0.1:3435/hospital/records_history \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>"}'

# 13. 添加新就诊记录
curl -X POST http://127.0.0.1:3435/hospital/add_record \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>","department":"内科","complaint":"头晕头痛","date":"2025-12-17"}'

# 14. 获取当前就诊概览
curl -X GET http://127.0.0.1:3435/hospital/current \
  -H "Content-Type: application/json" \
  -d '{"token":"<YOUR_TOKEN>"}'
