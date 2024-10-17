const express = require("express");
const { S3Client, ListObjectsV2Command } = require("@aws-sdk/client-s3");
const BUCKET_NAME = "test-boxx-test";
const REGION = "ap-south-1";

const s3Client = new S3Client({ region: REGION });
const app = express();

app.get("/list-bucket-content", async (req, res) => {
  try {
    const contentList = await listS3Objects();
    res.send({ content: contentList });
  } catch (error) {
    console.error("root level path api error", error);
    res.status(500).send({ error: "Error fetching S3 objects" });
  }
});

app.get("/list-bucket-content/*", async (req, res) => {
  const path = decodeURIComponent(req.path);
  const prefix = "/list-bucket-content/";
  const s3Prefix = path.slice(prefix.length);

  console.log(`You accessed the path: ${s3Prefix}`);

  try {
    const contentList = await listS3Objects(s3Prefix);
    res.send({ content: contentList });
  } catch (error) {
    console.error("sub level path api error", error);
    res.status(500).send({ error: "Error fetching S3 objects" });
  }
});

const listS3Objects = async (s3Prefix) => {
  try {
    const command = new ListObjectsV2Command({
      Bucket: BUCKET_NAME,
      Prefix: s3Prefix,
      Delimiter: "/",
    });

    const data = await s3Client.send(command);

    const contentList = [
      ...(data.CommonPrefixes || []).map((item) =>
        item.Prefix.split("/").filter(Boolean).pop()
      ),
      ...(data.Contents || [])
        .filter((item) => !item.Key.endsWith("/")) // Exclude the directory itself
        .map((item) => item.Key.split("/").pop()),
    ];

    return contentList;
  } catch (error) {
    console.error("Error fetching S3 objects:", error);
    throw new Error("Error fetching S3 objects");
  }
};

const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
  console.log(`Server is running on http://127.0.0.1:${PORT}`);
});
