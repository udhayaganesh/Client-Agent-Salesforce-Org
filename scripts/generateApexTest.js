const fs = require("fs");
const axios = require("axios");
const path = require("path");

const classesDir = "force-app/main/default/classes";

const files = fs
	.readdirSync(classesDir)
	.filter((f) => f.endsWith(".cls") && !f.endsWith("Test.cls"));

for (const file of files) {
	const className = file.replace(".cls", "");
	const testFile = `${className}Test.cls`;

	if (fs.existsSync(path.join(classesDir, testFile))) {
		continue; // test already exists
	}

	const apexCode = fs.readFileSync(path.join(classesDir, file), "utf8");

	const prompt = `
Generate a Salesforce Apex test class with at least 90% coverage.
Class name: ${className}
Code:
${apexCode}
`;

	axios
		.post(
			"https://api.openai.com/v1/chat/completions",
			{
				model: "gpt-4.1-mini",
				messages: [{ role: "user", content: prompt }],
			},
			{
				headers: {
					Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
				},
			},
		)
		.then((res) => {
			const testCode = res.data.choices[0].message.content;

			fs.writeFileSync(path.join(classesDir, testFile), testCode);

			console.log(`Generated ${testFile}`);
		});
}
