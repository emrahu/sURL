import sURLCore
let tool = sURL()
do{
    try tool.run()
} catch(let error){
    print("Error occured: \(error)")
}
