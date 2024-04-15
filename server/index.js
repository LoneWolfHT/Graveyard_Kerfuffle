var http = require("http");
var fs = require("fs");

var relatives = require("./relatives.json");

console.log("Creating server...");

http.createServer(function(request, result)
{
	if (request.method === "GET")
	{
		result.writeHead(200, { "Content-Type": "application/json" });
		result.write(JSON.stringify(relatives));
	}
	else if (request.method === "POST")
	{
		var data = ""

		request.on("data", function(chunk)
		{
			console.log(chunk)
			data += chunk.toString();
		})

		request.on("end", function()
		{
			console.log("Receiving submission...");
			console.log(data);

			try
			{
				data = JSON.parse(data);
			}
			catch(err)
			{
				console.log("Submission fail: %s", err);
				return
			}

			let newrelative = {};

			console.log(data);

			if (data.Name !== undefined && data.Head !== undefined && data.Body !== undefined && data.Wand !== undefined)
			{
				if (typeof(data.Name) == "string" && typeof(data.Head) == "number" && typeof(data.Body) == "number" && typeof(data.Wand) == "number")
				{
					if (data.Name.length >= 3 && data.Name.length <= 24)
					{
						newrelative.Name = data.Name;
						newrelative.Head = Math.min(5, Math.max(0, data.Head));
						newrelative.Body = Math.min(3, Math.max(0, data.Body));
						newrelative.Wand = Math.min(3, Math.max(0, data.Wand));

						relatives.push(newrelative);
						fs.writeFile(__dirname + "/relatives.json", JSON.stringify(relatives), function(err)
						{
							if (err) throw err;

							console.log('Success!');
							return
						});
					}
					else
					{
						console.log("Submission fail: Wrong name length");
					}
				}
				else
				{
					console.log("Submission fail: Wrong type(s)");
				}
			}
			else
			{
				console.log("Submission fail: Missing Data");
			}
		});

		result.writeHead(200);
	}
	else
	{
		result.writeHead(200);
	}

	result.end();
}).listen(30006, "0.0.0.0");
