import fs from 'fs/promises'
import crypto from 'crypto'


const { apikey, secretapikey, domain } = process.env

const out = `./cert`

async function fetchCert() {
  const keys = await fetch(`https://porkbun.com/api/json/v3/ssl/retrieve/${domain}`, {
    headers: { 'content-type': 'application/json' },
    method: "POST",
    body: JSON.stringify({
      apikey,
      secretapikey,
    })
  }).then(d => d.json())
  // await fs.writeFile('./cert.json',JSON.stringify(keys,null,2))
  console.log('update crt')
  try {
    await fs.stat(`${out}`)
  } catch (error) {
    await fs.mkdir(`${out}`)
  }
  await fs.writeFile(`${out}/${domain}.crt`, keys.certificatechain)
  await fs.writeFile(`${out}/${domain}.key`, keys.privatekey)
}

async function verifyCert() {
  let crt_old
  try {
    crt_old = new crypto.X509Certificate(await fs.readFile(`${out}/${domain}.crt`, 'utf-8'))
  } catch (error) {
    return false 
  }
  const validDays = ((new Date(crt_old.validTo).getTime() - Date.now()) / (1000 * 60 * 60 * 24)).toFixed(1)
  if (validDays > 0) {
    console.log(`过期时间：${crt_old.validTo}`)
    console.log(`还有${validDays}天过期。`)
    return true
  }
  console.log(`离${crt_old.validTo}, 已过期${Math.abs(validDays)}天。`)
  return false
}


(async () => {
  if (!apikey || !secretapikey || !domain){
    console.log("请在env中提供apikey、secretapikey以及domain")
    return
  }

  const res = await verifyCert()

  if (!res) {
    await fetchCert()
  }
})();
