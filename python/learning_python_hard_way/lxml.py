from lxml import etree

servers = etree.Element("servers", value="valid")
#ambientes.append(etree.Element("amb1"))

valid = etree.SubElement(servers, "valid")
valid.append(etree.Element("files_server"))
valid.append(etree.Element("database_servers"))
valid.append(etree.Element("database_name"))
valid.append(etree.Element("database_options"))


print(etree.tostring(servers, pretty_print=True))
